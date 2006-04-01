<?xml version="1.0" encoding="utf-8"?>

<!--

   svn2html.xsl - xslt stylesheet for converting svn log to a normal
                  changelog fromatted in html

   Usage (replace ++ with two minus signs):
     svn ++verbose ++xml log | \
       xsltproc ++stringparam strip-prefix `basename $(pwd)` \
                ++stringparam groupbyday yes \
                ++stringparam authorsfile FILE \
                svn2html.xsl - > ChangeLog.html

   This file is partially based on svn2cl.xsl.

   Copyright (C) 2005, 2006 Arthur de Jong.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:
   1. Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the
      distribution.
   3. The name of the author may not be used to endorse or promote
      products derived from this software without specific prior
      written permission.

   THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
   IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
   ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
   DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
   DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
   GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
   IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
   OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-->

<!DOCTYPE stylesheet [
 <!ENTITY newl "&#10;">
 <!ENTITY space "&#32;">
]>

<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

 <!-- include default formatting templates from svn2cl.xsl -->
 <xsl:include href="svn2cl.xsl" />

 <xsl:output
   method="xml"
   encoding="utf-8"
   media-type="text/html"
   omit-xml-declaration="no"
   standalone="yes"
   indent="yes"
   doctype-public="-//W3C//DTD XHTML 1.1//EN"
   doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" />

 <!-- match toplevel element -->
 <xsl:template match="log">
  <html>
   <head>
    <title>ChangeLog</title>
    <link rel="stylesheet" href="svn2html.css" type="text/css" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
   </head>
   <body>
    <ul class="changelog_entries">
     <xsl:apply-templates />
    </ul>
    <p class="changelog_footer">
     <xsl:text>Generated by </xsl:text><a href="http://ch.tudelft.nl/~arthur/svn2cl/">svn2cl 0.6</a>
    </p>
   </body>
  </html>
 </xsl:template>

 <!-- format one entry from the log -->
 <xsl:template match="logentry">
  <!-- save log entry number -->
  <xsl:variable name="pos" select="position()" />
  <!-- fetch previous entry's date -->
  <xsl:variable name="prevdate">
   <xsl:apply-templates select="../logentry[position()=(($pos)-1)]/date" />
  </xsl:variable>
  <!-- fetch previous entry's author -->
  <xsl:variable name="prevauthor">
   <xsl:apply-templates select="../logentry[position()=(($pos)-1)]/author" />
  </xsl:variable>
  <!-- fetch this entry's date -->
  <xsl:variable name="date">
   <xsl:apply-templates select="date" />
  </xsl:variable>
  <!-- fetch this entry's author -->
  <xsl:variable name="author">
   <xsl:apply-templates select="author" />
  </xsl:variable>
  <!-- check if header is changed -->
  <xsl:if test="($prevdate!=$date) or ($prevauthor!=$author)">
   <li class="changelog_entry">
    <!-- date -->
    <span class="changelog_date"><xsl:apply-templates select="date" /></span>
    <xsl:text>&space;</xsl:text>
    <!-- author's name -->
    <span class="changelog_author"><xsl:apply-templates select="author" /></span>
   </li>
  </xsl:if>
  <!-- entry -->
  <li class="changelog_change">
   <!-- get revision number -->
   <span class="changelog_revision">
    <a id="r{@revision}" href="#r{@revision}">[r<xsl:value-of select="@revision" />]</a>
   </span>
   <xsl:text>&space;</xsl:text>
   <!-- get paths string -->
   <span class="changelog_files"><xsl:apply-templates select="paths" /></span>
   <xsl:text>&space;</xsl:text>
   <!-- get message text -->
   <span class="changelog_message">
    <xsl:call-template name="newlinestobr">
     <xsl:with-param name="txt" select="msg" />
    </xsl:call-template>
   </span>
  </li>
 </xsl:template>

 <!-- template to replace line breaks with <br/> tags -->
 <xsl:template name="newlinestobr">
  <xsl:param name="txt" />
  <xsl:choose>
   <xsl:when test="contains($txt,'&newl;')">
     <!-- text contains newlines, do the first line -->
     <xsl:value-of select="substring-before($txt,'&newl;')" />
     <!-- print new line -->
     <br />
     <!-- wrap the rest of the text -->
     <xsl:call-template name="newlinestobr">
      <xsl:with-param name="txt" select="substring-after($txt,'&newl;')" />
     </xsl:call-template>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$txt" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

</xsl:stylesheet>
