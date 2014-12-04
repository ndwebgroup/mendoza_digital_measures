<xsl:if test="string-length(t:Data/t:Record/t:PCI/t:WEBSITE) &gt; 0">
  <h3>HOMEPAGE</h3>
  <ul class="arrowlist">
    <li>
      <a>
      <xsl:attribute name="href"><xsl:value-of select='concat("http://",t:Data/t:Record/t:PCI/t:WEBSITE)' /></xsl:attribute>
      <xsl:value-of select="t:Data/t:Record/t:PCI/t:WEBSITE" />
      </a>
    </li>
  </ul>
</xsl:if>
