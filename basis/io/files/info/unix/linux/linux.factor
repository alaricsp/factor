! Copyright (C) 2008 Doug Coleman.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors alien.c-types alien.syntax combinators csv
io.backend io.encodings.utf8 io.files io.files.info io.streams.string
io.files.unix kernel math.order namespaces sequences sorting
system unix unix.statfs.linux unix.statvfs.linux io.files.links
specialized-arrays.direct.uint arrays io.files.info.unix assocs
io.pathnames unix.types ;
FROM: csv => delimiter ;
IN: io.files.info.unix.linux

TUPLE: linux-file-system-info < unix-file-system-info
namelen ;

M: linux new-file-system-info linux-file-system-info new ;

M: linux file-system-statfs ( path -- byte-array )
    "statfs64" <c-object> [ statfs64 io-error ] keep ;

M: linux statfs>file-system-info ( struct -- statfs )
    {
        [ statfs64-f_type >>type ]
        [ statfs64-f_bsize >>block-size ]
        [ statfs64-f_blocks >>blocks ]
        [ statfs64-f_bfree >>blocks-free ]
        [ statfs64-f_bavail >>blocks-available ]
        [ statfs64-f_files >>files ]
        [ statfs64-f_ffree >>files-free ]
        [ statfs64-f_fsid 2 <direct-uint-array> >array >>id ]
        [ statfs64-f_namelen >>namelen ]
        [ statfs64-f_frsize >>preferred-block-size ]
        ! [ statfs64-f_spare >>spare ]
    } cleave ;

M: linux file-system-statvfs ( path -- byte-array )
    "statvfs64" <c-object> [ statvfs64 io-error ] keep ;

M: linux statvfs>file-system-info ( struct -- statfs )
    {
        [ statvfs64-f_flag >>flags ]
        [ statvfs64-f_namemax >>name-max ]
    } cleave ;

TUPLE: mtab-entry file-system-name mount-point type options
frequency pass-number ;

: mtab-csv>mtab-entry ( csv -- mtab-entry )
    [ mtab-entry new ] dip
    {
        [ first >>file-system-name ]
        [ second >>mount-point ]
        [ third >>type ]
        [ fourth <string-reader> csv first >>options ]
        [ 4 swap nth >>frequency ]
        [ 5 swap nth >>pass-number ]
    } cleave ;

: parse-mtab ( -- array )
    [
        "/etc/mtab" utf8 <file-reader>
        CHAR: \s delimiter set csv
    ] with-scope
    [ mtab-csv>mtab-entry ] map ;

M: linux file-systems
    parse-mtab [
        [ mount-point>> file-system-info ] keep
        {
            [ file-system-name>> >>device-name ]
            [ mount-point>> >>mount-point ]
            [ type>> >>type ]
        } cleave
    ] map ;

: (find-mount-point) ( path mtab-paths -- mtab-entry )
    2dup at* [
        2nip
    ] [
        drop [ parent-directory ] dip (find-mount-point)
    ] if ;

: find-mount-point ( path -- mtab-entry )
    canonicalize-path
    parse-mtab [ [ mount-point>> ] keep ] H{ } map>assoc (find-mount-point) ;

ERROR: file-system-not-found ;

M: linux file-system-info ( path -- )
    normalize-path
    [
        [ new-file-system-info ] dip
        [ file-system-statfs statfs>file-system-info ]
        [ file-system-statvfs statvfs>file-system-info ] bi
        file-system-calculations
    ] keep
    find-mount-point
    {
        [ file-system-name>> >>device-name drop ]
        [ mount-point>> >>mount-point drop ]
        [ type>> >>type ]
    } 2cleave ;
