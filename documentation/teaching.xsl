<xsl:variable name="cutoffyear" select=" $currentyear - 3" />
<xsl:variable name="cutoffdate" select='concat($cutoffyear,"-01-01")' />

<xsl:if test="count(t:Data/t:Record/t:SCHTEACH[number(translate(@d:startDate, '-', '')) &gt;= number(translate($cutoffdate, '-', ''))]) &gt; 0">
  <h3>TEACHING</h3>
  <ul class="arrowlist">
  <xsl:for-each select="t:Data/t:Record/t:SCHTEACH[number(translate(@d:startDate, '-', '')) &gt;= number(translate($cutoffdate, '-', ''))]/t:TITLE[not(.=preceding::t:TITLE)]">
  <li><xsl:value-of select="." /></li>
  </xsl:for-each>
  </ul>
</xsl:if>
