#!/bin/sh

XSL=svn2cl.xsl
STRIP_PREFIX=`dirname pwd`
LINELEN=75
GROUPBYDAY=no
INCLUDE_REV=no
CHANGELOG=Changelog

svn --verbose --xml log | \
  xsltproc --stringparam strip-prefix "$STRIP_PREFIX" \
           --stringparam linelen $LINELEN \
           --stringparam groupbyday $GROUPBYDAY \
           --stringparam include-rev $INCLUDE_REV \
           "$XSL" - > ChangeLog
