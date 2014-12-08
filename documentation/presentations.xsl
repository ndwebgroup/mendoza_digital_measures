<xsl:if test="count(t:Data/t:Record/t:PRESENT[t:WEBPAGE_INCLUDE='Yes']) &gt; 0">
  <h3>PRESENTATIONS</h3>
  <p>
    <xsl:for-each select="t:Data/t:Record/t:PRESENT[t:WEBPAGE_INCLUDE='Yes']">
      <xsl:for-each select="t:PRESENT_AUTH">
        <xsl:value-of select="concat(t:FNAME,' ',t:MNAME,' ',t:LNAME)" />,
      </xsl:for-each>
      <xsl:if test="string-length(t:NAME) &gt; 0"><xsl:value-of select="t:NAME" /></xsl:if><xsl:if test="string-length(t:ORG) &gt; 0">, <xsl:value-of select="t:ORG" /></xsl:if><xsl:if test="string-length(t:LOCATION) &gt; 0">, <xsl:value-of select="t:LOCATION" /></xsl:if><xsl:if test="string-length(t:NAME) != 0">,</xsl:if><xsl:if test="string-length(t:TITLE) &gt; 0"> "<xsl:value-of select="t:TITLE" /><xsl:choose><xsl:when test="substring(t:TITLE,string-length(t:TITLE)) = '?'">"</xsl:when><xsl:when test="substring(t:TITLE,string-length(t:TITLE)) != '?' and string-length(t:DTY_DATE) &gt; 0">," </xsl:when><xsl:when test="substring(t:TITLE,string-length(t:TITLE)) != '?' and string-length(t:DTY_DATE) &lt;= 0">."</xsl:when></xsl:choose></xsl:if>  <xsl:if test="string-length(t:DTY_DATE) &gt; 0"> (<xsl:if test="string-length(t:DTM_DATE) &gt; 0"><xsl:value-of select="t:DTM_DATE" /> <xsl:if test="string-length(t:DTD_DATE) &gt; 0"><xsl:value-of select="t:DTD_DATE" />,</xsl:if></xsl:if>&nbsp;<xsl:value-of select="t:DTY_DATE" />).</xsl:if>
      <br /><br />
    </xsl:for-each>
  </p>
</xsl:if>
