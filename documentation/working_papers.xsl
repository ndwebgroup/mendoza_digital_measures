<xsl:if test="count(t:Data/t:Record/t:RESPROG[t:WEBPAGE_INCLUDE='Yes' and (t:STATUS='Planning' or t:STATUS='Data Collection' or t:STATUS='Writing Results' or t:STATUS='Working Paper, Not submitted' or t:STATUS='Submitted' or t:STATUS ='Revision Requested' or t:STATUS='Resubmitted')]) &gt; 0">
  <h3>WORKING PAPERS</h3>
  <p>
    <xsl:for-each select="t:Data/t:Record/t:RESPROG[t:WEBPAGE_INCLUDE='Yes' and (t:STATUS='Planning' or t:STATUS='Data Collection' or t:STATUS='Writing Results' or t:STATUS='Working Paper, Not submitted' or t:STATUS='Submitted' or t:STATUS='Revision Requested' or t:STATUS='Resubmitted')]">

      <xsl:for-each select="t:RESPROG_COLL">
        <xsl:if test="string-length(t:NAME) &gt; 0">
          <xsl:value-of select="t:NAME" />,
        </xsl:if>
      </xsl:for-each>

      <xsl:choose>
        <xsl:when test="string-length(t:URL) &gt; 0 and t:URL != 'http://'">
          "<a>
          <xsl:attribute name="href"><xsl:value-of select="t:URL" /></xsl:attribute>
          <xsl:value-of select="t:TITLE" />
        </a>
        <xsl:choose>
          <xsl:when test="substring(t:TITLE,string-length(t:TITLE)) = '?'">"
          </xsl:when>
          <xsl:when test="substring(t:TITLE,string-length(t:TITLE)) != '?'">."
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="string-length(t:URL) &lt;= 0 or t:URL = 'http://'">
        "<xsl:value-of select="t:TITLE" />
        <xsl:choose>
          <xsl:when test="substring(t:TITLE,string-length(t:TITLE)) = '?'">"
          </xsl:when>
          <xsl:when test="substring(t:TITLE,string-length(t:TITLE)) != '?'">."
          </xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
    <br /><br />
  </xsl:for-each>
</p>
</xsl:if>
