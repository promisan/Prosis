<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfoutput>
               <assist role="TR"/>
               <field name="Num" w="30mm" h="#vHeight#mm" access="readOnly">
                  <ui>
                     <textEdit/>
                  </ui>
                  <font typeface="Myriad Pro" size="8pt"/>
                  <margin topInset="0.5mm" bottomInset="0.5mm" leftInset="0.5mm" rightInset="0.5mm"/>
                  <para vAlign="middle" hAlign="right"/>
                  <border>
                     <edge/>
                     <corner thickness="0.1778mm"/>
                  </border>
                  <value>
                     <text><cfif vCount lt 10>0#vCount#<cfelse>#vCount#</cfif></text>
                  </value>
                  <bind match="none"/>
               </field>

				<field name="LogTime" w="30mm" h="#vHeight#mm">
                  <ui>
                     <dateTimeEdit/>
                  </ui>
                  <font typeface="Myriad Pro" size="8pt"/>
                  <margin topInset="0.5mm" bottomInset="0.5mm" leftInset="0.5mm" rightInset="0.5mm"/>
                  <para vAlign="middle"/>
                  <value>
                     <time/>
                  </value>
                  <border>
                     <edge/>
                     <corner thickness="0.1778mm"/>
                  </border>
                  <validate formatTest="error">
                     <picture>time{h:MM A}</picture>
                  </validate>
               </field>   
			   
			   
               <field name="Plate" w="30mm" h="#vHeight#mm">
                  <ui>
                     <textEdit/>
                  </ui>
                  <font typeface="Myriad Pro" size="8pt"/>
                  <margin topInset="0.5mm" bottomInset="0.5mm" leftInset="0.5mm" rightInset="0.5mm"/>
                  <para vAlign="middle" hAlign="left"/>
                  <border>
                     <edge/>
                     <corner thickness="0.1778mm"/>
                  </border>
                  <value>
                     <text maxChars="20"/>
                  </value>
               </field>

               <field name="Barcode" w="30mm" h="#vHeight#mm">
                  <ui>
                     <textEdit/>
                  </ui>
                  <font typeface="Myriad Pro" size="8pt"/>
                  <margin topInset="0.5mm" bottomInset="0.5mm" leftInset="0.5mm" rightInset="0.5mm"/>
                  <para vAlign="middle" hAlign="center"/>
                  <border>
                     <edge/>
                     <corner thickness="0.1778mm"/>
                  </border>
                  <value>
                     <text maxChars="20"/>
                  </value>
               </field>			   
			   
               <field name="Metric" w="30mm" h="#vHeight#mm">
                  <ui>
                     <numericEdit/>
                  </ui>
                  <font typeface="Myriad Pro" size="8pt"/>
                  <margin topInset="0.5mm" bottomInset="0.5mm" leftInset="0.5mm" rightInset="0.5mm"/>
                  <para vAlign="middle" hAlign="right"/>
                  <value>
                     <decimal/>
                  </value>
                  <border>
                     <edge/>
                     <corner thickness="0.1778mm"/>
                  </border>
               </field>			   
			   
               <field name="UNID" w="30mm" h="#vHeight#mm">
                  <ui>
                     <textEdit/>
                  </ui>
                  <font typeface="Myriad Pro" size="8pt"/>
                  <margin topInset="0.5mm" bottomInset="0.5mm" leftInset="0.5mm" rightInset="0.5mm"/>
                  <para vAlign="middle" hAlign="left"/>
                  <border>
                     <edge/>
                     <corner thickness="0.1778mm"/>
                  </border>
                  <value>
                     <text maxChars="20"/>
                  </value>
               </field>

               <field name="Recipient_name" w="30mm" h="#vHeight#mm">
                  <ui>
                     <textEdit/>
                  </ui>
                  <font typeface="Myriad Pro" size="8pt"/>
                  <margin topInset="0.5mm" bottomInset="0.5mm" leftInset="0.5mm" rightInset="0.5mm"/>
                  <para vAlign="middle" hAlign="left"/>
                  <border>
                     <edge/>
                     <corner thickness="0.1778mm"/>
                  </border>
                  <value>
                     <text maxChars="50"/>
                  </value>
               </field>
			   
			   
               <field name="Unit" w="20.07mm" h="#vHeight#mm">
                  <ui>
                     <choiceList/>
                  </ui>
                  <font typeface="Myriad Pro" size="8pt"/>
                  <margin topInset="0.5mm" bottomInset="0.5mm" leftInset="0.5mm" rightInset="0.5mm"/>
                  <para vAlign="middle" hAlign="left"/>
                  <border>
                     <edge/>
                     <corner thickness="0.1778mm"/>
                  </border>
				   
					<cfquery name="qOrganizations" datasource="AppsOrganization">
						SELECT OrgUnit,OrgUnitCode,OrgUnitName from Organization
						WHERE Mission = '#vMission#'
						AND MandateNo = '#qMandate.MandateNo#'
						ORDER by HierarchyCode
					</cfquery>
		            <items>
						<cfloop query="qOrganizations">
			               <text>#OrgUnitName#(#OrgUnitCode#)</text>
						 </cfloop>  
		            </items> 					
		            <items save="1" presence="hidden">
						<cfloop query="qOrganizations">
			               <text>#orgUnit#</text>
						 </cfloop>  
		             </items>										
						  
               </field>
			   
			   
               <field name="Reference" w="30mm" h="#vHeight#mm">
                  <ui>
                     <textEdit/>
                  </ui>
                  <font typeface="Myriad Pro" size="8pt"/>
                  <margin topInset="0.5mm" bottomInset="0.5mm" leftInset="0.5mm" rightInset="0.5mm"/>
                  <para vAlign="middle" hAlign="left"/>
                  <border>
                     <edge/>
                     <corner thickness="0.1778mm"/>
                  </border>
                  <value>
                     <text maxChars="20"/>
                  </value>
               </field>
			   
               <field name="Qty" w="30mm" minH="#vHeight#mm">
                  <ui>
                     <numericEdit/>
                  </ui>
                  <font typeface="Myriad Pro" size="8pt"/>
                  <margin topInset="0.5mm" bottomInset="0.5mm" leftInset="0.5mm" rightInset="0.5mm"/>
                  <para vAlign="middle" hAlign="right"/>
                  <value>
                     <decimal/>
                  </value>
                  <border>
                     <edge/>
                     <corner thickness="0.1778mm"/>
                  </border>
	  
               </field>
			   

               <border>
                  <edge presence="hidden"/>
                  <fill>
                     <color value="240,240,240"/>
                  </fill>
               </border>
               <occur max="-1"/>
               <?templateDesigner rowpattern first:1, next:1, firstcolor:f0f0f0, nextcolor:ffffff, apply:1?>
               <?templateDesigner expand 1?>
</cfoutput>			   