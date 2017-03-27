module Puppet::Parser::Functions
  require 'pathname'
  newfunction(:autofs_mapper, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Takes a directory (absolute path) or /^wildcard-\/path\/to\/mountpoint/ and
    returns the mountpoint and key used to mount the directory via autofs.

    By default, the mountpoint is assumed to be indirect.  Users can opt to
    direct mount by specifying 'direct'.

    If you wish to have more control over your auto.master and auto.map files,
    you can use autofs::map::master and autofs::map::entry, respectively.
    ENDHEREDOC

    map_type = 'indirect'
    target = args[0]

    if args.length < 1 or args.length > 2
      raise Puppet::ParseError, ("autofs_mapper(): wrong number of arguments\
 (#{args.length}); you must specify a [wildcard-]/target/directory and may
 optionally specify a map type")
    end
    if args[1]
      if ['indirect','direct'].include? args[1]
        map_type = args[1]
      else
        raise Puppet::ParseError, ("autofs_mapper(): expects the second\
 argument to be 'direct' or 'indirect'")
      end
    end

    # If wildcard- is specified, it will be split from the target. If it
    # is not specified, wildcard will be nil.
    wildcard = target.slice!('wildcard-')
    unless Pathname.new(target).absolute?
      raise Puppet::ParseError, ("autofs_mapper(): expects target to be\
 an absolute path, got #{target}")
    end
    if target == '/'
      raise Puppet::ParseError, ("autofs_mapper(): you cannot mount on /")
    end

    if wildcard
      if map_type == 'direct'
        raise Puppet::ParseError, ("autofs_mapper(): you cannot direct mount\
 wildcards.")
      else
        return target,'*'
      end
    else
      if map_type == 'indirect' and args[0].scan(/\//).count == 1
        raise Puppet::ParseError, ("autofs_mapper(): you cannot indirect mount\
 on /<foo>. You must direct mount, or specify a mount point /<foo>/<bar>.")
      else
        # Split the last directory off of the target. Use the first element
        # as the mountpoint, use the second as the key.
      end
    end

    return 'blah'
  end
end
