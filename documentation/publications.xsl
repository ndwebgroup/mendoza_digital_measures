<h3>PUBLICATIONS</h3>
<p>

<xsl:for-each select="t:Data/t:Record/t:INTELLCONT[t:WEBPAGE_INCLUDE='Yes' and (t:CONTYPE='Journal Articles, Refereed' or t:CONTYPE='Journal Articles, Non-Refereed' or t:CONTYPE='Other')]">

  <xsl:choose>
    <xsl:when test="string-length(t:WEB_ADDRESS) &gt; 0">
    <a>
    <xsl:attribute name="href"><xsl:value-of select="t:WEB_ADDRESS" /></xsl:attribute>
    "<xsl:value-of select="t:TITLE" />
    </a>
    </xsl:when>
    <xsl:when test="string-length(t:WEB_ADDRESS) &lt;= 0">
    "<xsl:value-of select="t:TITLE" />
    </xsl:when>
  </xsl:choose>

  <xsl:if test="substring(t:TITLE,string-length(t:TITLE)) != '?'">,</xsl:if>"
  <!--
  <xsl:if test="count(t:INTELLCONT_AUTH[t:FNAME != $thisFname and t:LNAME != $thisLname]) &gt; 0">
  (with
    <xsl:for-each select="t:INTELLCONT_AUTH">

    <xsl:choose>
      <xsl:when test="t:FNAME != $thisFname and t:LNAME != $thisLname and position()!=last()">
      <xsl:value-of select="concat(t:FNAME,' ',t:MNAME,' ',t:LNAME)" />,
      </xsl:when>
      <xsl:when test="t:FNAME != $thisFname and t:LNAME != $thisLname and position()=last()">
      <xsl:value-of select="concat(t:FNAME,' ',t:MNAME,' ',t:LNAME)" />
      </xsl:when>
    </xsl:choose>

    </xsl:for-each>),
  </xsl:if>
  -->

  <xsl:if test="count(t:INTELLCONT_AUTH[t:FACULTY_NAME != $thisUserId]) &gt; 0">
    (with
    <xsl:for-each select="t:INTELLCONT_AUTH">
      <xsl:choose>
        <xsl:when test="t:FACULTY_NAME != $thisUserId and position()!=last()">
        <xsl:value-of select="concat(t:FNAME,' ',t:MNAME,' ',t:LNAME)" />,
        </xsl:when>
        <xsl:when test="t:FACULTY_NAME != $thisUserId and position()=last()">
        <xsl:value-of select="concat(t:FNAME,' ',t:MNAME,' ',t:LNAME)" />
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>),
  </xsl:if>

<xsl:if test="t:STATUS = 'Accepted'">
  To appear in</xsl:if>&nbsp;
  <i><xsl:value-of select="t:PUBLISHER" /></i>
    <xsl:if test="string-length(t:VOLUME) &gt; 0">,
      <xsl:value-of select="t:VOLUME" />
    </xsl:if>
    <xsl:if test="string-length(t:DTM_PUB) &gt; 0">,
      <xsl:value-of select="t:DTM_PUB" />
        <xsl:if test="string-length(t:DTD_PUB) &gt; 0">
          <xsl:value-of select="t:DTD_PUB" />
        </xsl:if>
      </xsl:if>

      <xsl:if test="string-length(t:DTY_PUB) &gt; 0">,
        <xsl:value-of select="t:DTY_PUB" />
      </xsl:if>
      <xsl:if test="string-length(t:PAGENUM) &gt; 0">,
        <xsl:value-of select="t:PAGENUM" />
      </xsl:if>.

      <br /><br />
  </xsl:for-each>
</p>
