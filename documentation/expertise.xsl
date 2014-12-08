<xsl:if test="count(t:Data/t:Record/t:PCI/t:PCI_EXPERTISE) &gt; 0">
  <h3>AREAS OF EXPERTISE</h3>
  <ul class="arrowlist nolinks">
    <xsl:for-each select="t:Data/t:Record/t:PCI/t:PCI_EXPERTISE">
      <li><xsl:value-of select="t:EXPERTISE" /></li>
    </xsl:for-each>
  </ul>
</xsl:if>
