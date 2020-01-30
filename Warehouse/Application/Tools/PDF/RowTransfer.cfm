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
			   
			   
               <field name="Destination" w="30mm" h="#vHeight#mm">
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
				   
				  <cfquery name="qLocations" datasource="AppsMaterials">
						SELECT Location,Description
						FROM WarehouseLocation
						WHERE Warehouse = '#Warehouse#'		 				
				   </cfquery>
		
		           <items>
						<cfloop query = "qLocations">
			               <text>#Description#</text>
						</cfloop> 
			        </items> 
		            <items save="1" presence="hidden">
						<cfloop query = "qLocations">
			               <text>#Location#</text>
						</cfloop> 
		             </items>									
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