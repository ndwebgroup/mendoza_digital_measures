<xsl:if test="count(t:Data/t:Record/t:EDUCATION) &gt; 0">
  <h3>EDUCATION</h3>
  <ul class="arrowlist nolinks">
    <xsl:for-each select="t:Data/t:Record/t:EDUCATION">
      <li><xsl:choose>
      <xsl:when test="t:DEG = 'Other'"><xsl:value-of select="t:DEGOTHER" /></xsl:when>
      <xsl:when test="t:DEG != 'Other'"><xsl:value-of select="t:DEG" /></xsl:when>
      </xsl:choose>, <xsl:value-of select="t:SCHOOL" /></li>
  </xsl:for-each>
  </ul>
</xsl:if>

<xsl:variable name="currentyear">
  <xsl:call-template name="dt:get-xsd-datetime-year">
    <xsl:with-param name="xsd-date-time" select="t:Data/@d:date"/>
  </xsl:call-template>
</xsl:variable>
