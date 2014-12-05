<?xml version="1.0" encoding="utf-8"?><!-- DWXMLSource="facultyBio.xml" --><!DOCTYPE xsl:stylesheet  [
	<!ENTITY nbsp   "&#160;">
	<!ENTITY copy   "&#169;">
	<!ENTITY reg    "&#174;">
	<!ENTITY trade  "&#8482;">
	<!ENTITY mdash  "&#8212;">
	<!ENTITY ldquo  "&#8220;">
	<!ENTITY rdquo  "&#8221;">
	<!ENTITY pound  "&#163;">
	<!ENTITY yen    "&#165;">
	<!ENTITY euro   "&#8364;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.digitalmeasures.com/schema/data" xmlns:d="http://www.digitalmeasures.com/schema/data-metadata" xmlns:dt="http://xsltsl.org/date-time">

<xsl:import href="xsltsl-1.2.1/date-time.xsl"/>

<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
<xsl:template match="/">


			<h1>Faculty &amp; Research</h1>

            <div id="content" class="floatwrapper">
				<div id="biosynopsis" class="floatwrapper">

                	<img width="150" height="150" class="biodetail">
                        <xsl:attribute name="src">
                            <xsl:value-of select='concat("/images/facultyandstaff/150x150/",t:Data/t:Record/@username,"_150x150.jpg")'/>
                        </xsl:attribute>
                        <xsl:attribute name="alt">
                            <xsl:value-of select='concat("Photo of ",t:Data/t:Record/t:PCI/t:FNAME,t:Data/t:Record/t:PCI/t:MNAME,t:Data/t:Record/t:PCI/t:LNAME)'/>
                        </xsl:attribute>
                    </img>

                    <div class="content">
						<h2><xsl:value-of select="t:Data/t:Record/t:PCI/t:FNAME" /> <xsl:if test="t:Data/t:Record/t:PCI/t:MNAME != ''"><xsl:value-of select="concat(' ',t:Data/t:Record/t:PCI/t:MNAME)" /></xsl:if> <xsl:value-of select="concat(' ',t:Data/t:Record/t:PCI/t:LNAME)" /><xsl:if test="t:Data/t:Record/t:PCI/t:SUFFIX != ''"><xsl:value-of select="concat(' ',t:Data/t:Record/t:PCI/t:SUFFIX)" /></xsl:if></h2>
                        <!-- 140305 PGC added the SUFFIX -->
						<p>
                        <xsl:comment>120313 pgc adjust rank/title for new teaching title</xsl:comment>
                        <xsl:comment><xsl:value-of select="t:Data/t:Record/t:ADMIN/t:RANK" /></xsl:comment>
                        <xsl:choose>
                            <xsl:when test="t:Data/t:Record/@username = 'jorourke'">Teaching Professor of Management</xsl:when>
                            <xsl:when test="t:Data/t:Record/@username = 'sbyrnes1'">Associate Teaching Professor of Management</xsl:when>
                            <xsl:when test="t:Data/t:Record/@username = 'scollin1'">Associate Teaching Professor of Management</xsl:when>
                            <xsl:when test="t:Data/t:Record/@username = 'etuleja'">Associate Teaching Professor of Management</xsl:when>
                            <xsl:when test="t:Data/t:Record/@username = 'jmcmanus'">Associate Teaching Professor of Management</xsl:when>
                            <xsl:when test="t:Data/t:Record/@username = 'amckendr'">Associate Teaching Professor of Management</xsl:when>
                            <xsl:when test="t:Data/t:Record/@username = 'blevey'">Teaching Professor</xsl:when>
                            <xsl:when test="t:Data/t:Record/@username = 'tmurphy1'">Teaching Professor</xsl:when>
                            <xsl:when test="t:Data/t:Record/@username = 'jfuehrme'">MSA Program Faculty Director and Associate Teaching Professor</xsl:when>
                            <xsl:when test="t:Data/t:Record/@username = 'gbern'">Academic Director, Master of Science in Finance and Associate Teaching Professor</xsl:when>
                            <xsl:when test="t:Data/t:Record/@username = 'dkleinmu'">Academic Director, Master of Science in Business Analytics and Professor of the Practice</xsl:when>
                            <xsl:when test="t:Data/t:Record/@username = 'smille27'">Director of the Gigot Center for Entrepreneurship and Concurrent Associate Professional Specialist</xsl:when>
                            <xsl:otherwise><xsl:value-of select="t:Data/t:Record/t:ADMIN/t:RANK" /></xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="t:Data/t:Record/t:PCI/t:ENDPOS != ''">
                        <br />
						<em><xsl:value-of select="t:Data/t:Record/t:PCI/t:ENDPOS" /></em>
                        </xsl:if>
                        </p>
					</div>
				</div>


                <div class="tabwrapper">
                    <ul class="tabbed floatwrapper">
                        <li><a href="#tab1" id="bio"><span>Bio</span></a></li>
                        <xsl:if test="count(t:Data/t:Record/t:PRESENT[t:WEBPAGE_INCLUDE='Yes']) &gt; 0 or count(t:Data/t:Record/t:INTELLCONT[t:WEBPAGE_INCLUDE='Yes']) &gt; 0 or count(t:Data/t:Record/t:RESPROG[t:WEBPAGE_INCLUDE='Yes' and (t:STATUS='Planning' or t:STATUS='Data Collection' or t:STATUS='Writing Results' or t:STATUS='Working Paper, Not submitted' or t:STATUS='Submitted' or t:STATUS ='Revision Requested' or t:STATUS='Resubmitted')]) &gt; 0">
                        <li><a href="#tab2" id="research"><span>Research</span></a></li>
                        </xsl:if>
                    </ul>

                    <div class="tabbedcontent extendedbox">
						<div class="hook1">
							<div class="hook2">

								<!-- Tab 1 -->
								<div id="tab1">
									<xsl:if test="string-length(t:Data/t:Record/t:PCI/t:BIO) &gt; 10">
                                    <h3>BIO</h3>
									<p><xsl:value-of select="t:Data/t:Record/t:PCI/t:BIO" disable-output-escaping="yes" /></p>
									</xsl:if>

                                    <xsl:if test="count(t:Data/t:Record/t:PCI/t:PCI_EXPERTISE) &gt; 0">
									<h3>AREAS OF EXPERTISE</h3>
									<ul class="arrowlist nolinks">
                                    	<xsl:for-each select="t:Data/t:Record/t:PCI/t:PCI_EXPERTISE">
										<li><xsl:value-of select="t:EXPERTISE" /></li>
										</xsl:for-each>
									</ul>
									</xsl:if>

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
                                            <xsl:with-param name="xsd-date-time" select="t:Data/@d:date"/>                                          </xsl:call-template>
                                    </xsl:variable>
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
								</div>

                                <xsl:variable name="thisFname" select="t:Data/t:Record/t:PCI/t:FNAME" />
                                <xsl:variable name="thisLname" select="t:Data/t:Record/t:PCI/t:LNAME" />
                                <xsl:variable name="thisUserId" select="t:Data/t:Record/@userId" />


                                <!-- Tab 2 -->
                                <xsl:if test="count(t:Data/t:Record/t:PRESENT[t:WEBPAGE_INCLUDE='Yes']) &gt; 0 or count(t:Data/t:Record/t:INTELLCONT[t:WEBPAGE_INCLUDE='Yes']) &gt; 0 or count(t:Data/t:Record/t:RESPROG[t:WEBPAGE_INCLUDE='Yes' and (t:STATUS='Planning' or t:STATUS='Data Collection' or t:STATUS='Writing Results' or t:STATUS='Working Paper, Not submitted' or t:STATUS='Submitted' or t:STATUS ='Revision Requested' or t:STATUS='Resubmitted')]) &gt; 0">
								<div id="tab2">
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
                                            <!--<xsl:if test="count(t:INTELLCONT_AUTH[t:FNAME != $thisFname and t:LNAME != $thisLname]) &gt; 0">
                                            	(with <xsl:for-each select="t:INTELLCONT_AUTH">
                                                		<xsl:choose>
                                                        	<xsl:when test="t:FNAME != $thisFname and t:LNAME != $thisLname and position()!=last()">
                                                            	<xsl:value-of select="concat(t:FNAME,' ',t:MNAME,' ',t:LNAME)" />,
                                                            </xsl:when>
                                                            <xsl:when test="t:FNAME != $thisFname and t:LNAME != $thisLname and position()=last()">
                                                            	<xsl:value-of select="concat(t:FNAME,' ',t:MNAME,' ',t:LNAME)" />
                                                            </xsl:when>
                                                        </xsl:choose>
                                                       </xsl:for-each>),
                                            </xsl:if>-->

                                            <xsl:if test="count(t:INTELLCONT_AUTH[t:FACULTY_NAME != $thisUserId]) &gt; 0">
                                            	(with <xsl:for-each select="t:INTELLCONT_AUTH">
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

                                            <xsl:if test="t:STATUS = 'Accepted'">To appear in</xsl:if>&nbsp;<i><xsl:value-of select="t:PUBLISHER" /></i><xsl:if test="string-length(t:VOLUME) &gt; 0">, <xsl:value-of select="t:VOLUME" /></xsl:if><xsl:if test="string-length(t:DTM_PUB) &gt; 0">, <xsl:value-of select="t:DTM_PUB" /><xsl:if test="string-length(t:DTD_PUB) &gt; 0"><xsl:value-of select="t:DTD_PUB" /></xsl:if></xsl:if><xsl:if test="string-length(t:DTY_PUB) &gt; 0">, <xsl:value-of select="t:DTY_PUB" /></xsl:if><xsl:if test="string-length(t:PAGENUM) &gt; 0">, <xsl:value-of select="t:PAGENUM" />
																						</xsl:if>.
                                            <br /><br />
                                        </xsl:for-each>
                                    </p>

                                    <xsl:if test="count(t:Data/t:Record/t:INTELLCONT[t:WEBPAGE_INCLUDE='Yes' and (t:CONTYPE='Book, Referred Article' or t:CONTYPE='Book, Review' or t:CONTYPE='Book, Scholarly-Contributed Chapter')]) &gt; 0">
                                    <h3>Book Articles and Chapters</h3>
									<p>
                                    	<xsl:for-each select="t:Data/t:Record/t:INTELLCONT[t:WEBPAGE_INCLUDE='Yes' and (t:CONTYPE='Book, Referred Article' or t:CONTYPE='Book, Review' or t:CONTYPE='Book, Scholarly-Contributed Chapter')]">

                                        	<xsl:choose>
                                            	<xsl:when test="string-length(t:WEB_ADDRESS) &gt; 0">
                                                	<a>
                                                    	<xsl:attribute name="href"><xsl:value-of select="t:WEB_ADDRESS" /></xsl:attribute>
                                                        <xsl:value-of select="t:TITLE" />
                                                    </a>
                                             	</xsl:when>
                                                <xsl:when test="string-length(t:WEB_ADDRESS) &lt;= 0">
                                                	<xsl:value-of select="t:TITLE" />                                                </xsl:when>
                                            </xsl:choose>
                                            <xsl:if test="substring(t:TITLE,string-length(t:TITLE)) != '?'">,
                                            </xsl:if>
                                            <!--<xsl:if test="count(t:INTELLCONT_AUTH[t:FNAME != $thisFname and t:LNAME != $thisLname]) &gt; 0">
                                            	(with <xsl:for-each select="t:INTELLCONT_AUTH">
                                                		<xsl:choose>
                                                        	<xsl:when test="t:FNAME != $thisFname and t:LNAME != $thisLname and position()!=last()">
                                                            	<xsl:value-of select="concat(t:FNAME,' ',t:MNAME,' ',t:LNAME)" />,
                                                            </xsl:when>
                                                            <xsl:when test="t:FNAME != $thisFname and t:LNAME != $thisLname and position()=last()">
                                                            	<xsl:value-of select="concat(t:FNAME,' ',t:MNAME,' ',t:LNAME)" />
                                                            </xsl:when>
                                                        </xsl:choose>
                                                       </xsl:for-each>),
                                            </xsl:if>-->

                                            <xsl:if test="count(t:INTELLCONT_AUTH[t:FACULTY_NAME != $thisUserId]) &gt; 0">
                                            	(with <xsl:for-each select="t:INTELLCONT_AUTH">
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

                                            <i><xsl:value-of select="t:PUBLISHER" /></i> (<xsl:if test="string-length(t:DTM_PUB) &gt; 0"><xsl:value-of select="t:DTM_PUB" /><xsl:if test="string-length(t:DTD_PUB) &gt; 0"> <xsl:value-of select="t:DTD_PUB" />, </xsl:if></xsl:if><xsl:if test="string-length(t:DTY_PUB) &gt; 0"><xsl:value-of select="t:DTY_PUB" /></xsl:if>).
                                            <br /><br />
                                        </xsl:for-each>
                                    </p>
							        </xsl:if>

                                    <xsl:if test="count(t:Data/t:Record/t:INTELLCONT[t:WEBPAGE_INCLUDE='Yes' and (t:CONTYPE='Book, Scholarly' or t:CONTYPE='Book, Textbook-New' or t:CONTYPE='Book, Textbook-Revised')]) &gt; 0">
                                    <h3>Books</h3>
									<p>
                                    	<xsl:for-each select="t:Data/t:Record/t:INTELLCONT[t:WEBPAGE_INCLUDE='Yes' and (t:CONTYPE='Book, Scholarly' or t:CONTYPE='Book, Textbook-New' or t:CONTYPE='Book, Textbook-Revised')]">

                                        	<xsl:choose>
                                            	<xsl:when test="string-length(t:WEB_ADDRESS) &gt; 0">
                                                	<a>
                                                    	<xsl:attribute name="href"><xsl:value-of select="t:WEB_ADDRESS" /></xsl:attribute>
                                                        <xsl:value-of select="t:TITLE" />
                                                    </a>
                                             	</xsl:when>
                                                <xsl:when test="string-length(t:WEB_ADDRESS) &lt;= 0">
                                                	<xsl:value-of select="t:TITLE" />                                                </xsl:when>
                                            </xsl:choose>
                                            <xsl:if test="substring(t:TITLE,string-length(t:TITLE)) != '?'">,
                                            </xsl:if>
                                            <xsl:if test="count(t:INTELLCONT_AUTH[t:FNAME != $thisFname and t:LNAME != $thisLname]) &gt; 0">
                                            	(with <xsl:for-each select="t:INTELLCONT_AUTH">
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
                                            <i><xsl:value-of select="t:PUBLISHER" /></i> (<xsl:if test="string-length(t:DTM_PUB) &gt; 0"><xsl:value-of select="t:DTM_PUB" /><xsl:if test="string-length(t:DTD_PUB) &gt; 0"> <xsl:value-of select="t:DTD_PUB" />, </xsl:if></xsl:if><xsl:if test="string-length(t:DTY_PUB) &gt; 0"><xsl:value-of select="t:DTY_PUB" /></xsl:if>).
                                            <br /><br />
                                        </xsl:for-each>
                                    </p>
							        </xsl:if>

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

								</div>
                                </xsl:if>
							</div>
						</div>
					</div>

                    <ul class="arrowlist blue vita">
                        <li>
                        <a class="vita" target="_blank">
                            <xsl:attribute name="href"><xsl:value-of select='concat("/Documents_pdf/facultyvita/",t:Data/t:Record/@username,".pdf")'/></xsl:attribute>
                            DOWNLOAD VITA (PDF)
                        </a>
                        </li>
                    </ul>

                </div>

			</div>

            <div id="sidebar">
				<div class="bluebox">
					<div class="hook1">
						<div class="hook2">
							<h2>CONTACT</h2>

							<h3>OFFICE:</h3>
							<p><xsl:value-of select="t:Data/t:Record/t:PCI/t:ROOMNUM" /> Mendoza College of Business<br />
							Notre Dame, Indiana 46556-5646</p>

							<h3>PHONE:</h3>
							<p>(<xsl:value-of select="t:Data/t:Record/t:PCI/t:OPHONE1" />) <xsl:value-of select="t:Data/t:Record/t:PCI/t:OPHONE2" />-<xsl:value-of select="t:Data/t:Record/t:PCI/t:OPHONE3" /></p>

							<h3>EMAIL:</h3>
							<p><a>
                            	<xsl:attribute name="href">mailto:<xsl:value-of select="t:Data/t:Record/t:PCI/t:EMAIL" /></xsl:attribute>
                             	<xsl:value-of select="t:Data/t:Record/t:PCI/t:EMAIL" />
                               </a></p>
						</div>
					</div>
				</div>

                <xsl:comment><xsl:choose>
                    <xsl:when test="t:Data/t:Record/@username = 'cywoo'">

                    	<div class="whitebox">
                            <div class="hook1">
                                <div class="hook2">
                                    <h2 class="link"><a href="/deanwooinitiatives/">Dean Woo Initiatives</a></h2>
                                    <h2 class="link"><a href="http://blogs.nd.edu/deanwoo/" target="_blank">ND Dean Woo: Ask More of Business </a></h2>
                                </div>
                            </div>
						</div>
                    </xsl:when>
                </xsl:choose></xsl:comment>


			</div>





</xsl:template>


</xsl:stylesheet>
