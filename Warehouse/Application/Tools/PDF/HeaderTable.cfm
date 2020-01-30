
<cfoutput>
	<subform layout="row" name="HeaderRow1">
          <assist role="TR"/>

         <field name="Mission" w="#vWidth#mm" h="#vHeight#mm" access="readOnly">
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
            <caption reserve="25mm">
               <para vAlign="middle"/>
                <value>
                    <text>Mission:</text>
                </value>
             </caption>				
			<value>
				<text>#vMission#</text>
			</value>
         </field>
		 


		 
         <field name="Location" w="#vWidth*2#mm" h="#vHeight#mm">
            <ui>
               <choiceList>
                  <border presence="hidden">
                     <?templateDesigner StyleID aped0?></border>
               </choiceList>
            </ui>
            <font typeface="Myriad Pro" size="8pt"/>
            <margin topInset="0.5mm" bottomInset="0.5mm" leftInset="0.5mm" rightInset="0.5mm"/>
            <para vAlign="middle" hAlign="left"/>
            <border>
               <edge/>
               <corner thickness="0.1778mm"/>
            </border>
            <caption reserve="25mm">
               <para vAlign="middle"/>
                <value>
                    <text>Storage Tank:</text>
                </value>
             </caption>				
			
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

		 
	</subform>
	<subform layout="row" name="HeaderRow2">		 
		 <assist role="TR"/>
		 

         <field name="Item" w="#vWidth#mm" h="#vHeight#mm" >
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
            <caption reserve="25mm">
               <para vAlign="middle"/>
                <value>
                    <text>Product:</text>
                </value>
             </caption>							
			<cfquery name= "qItem" datasource = "AppsMaterials">
				SELECT ItemNo,ItemDescription
				FROM Item
				WHERE Category = '#vCategory#'	
				AND 
				ItemNo IN
				(
					SELECT ItemNo FROM 
					ItemWarehouseLocation
					WHERE Warehouse = '#Warehouse#'		
				)
				
			</cfquery>

			
            <items>
				<cfloop query ="qItem">
	               <text>#ItemDescription#</text>
				</cfloop>		
	        </items> 	
			
            <items save="1" presence="hidden">
				<cfloop query ="qItem">
	               <text>#itemNo#</text>
				</cfloop>		
             </items>					
         </field>
		 
         <field name="Officer" w="#vWidth*2#mm" h="#vHeight#mm">
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
            <caption reserve="25mm">
               <para vAlign="middle"/>
                <value>
                    <text>Officer:</text>
                </value>
             </caption>							
			<cfquery name = "qUsers" datasource = "AppsOrganization">
					SELECT Distinct U.Account, U.FirstName + ' ' + U.LastName as FullName
					FROM OrganizationAuthorization OA INNER JOIN
					System.dbo.UserNames U ON OA.UserAccount = U.Account
					WHERE Role='WhsPick' AND Mission ='#vMission#'
					AND FirstName IS NOT NULL
					AND (OrgUnit IS null or OrgUnit in 
					(
						SELECT OrgUnit
						FROM Organization
						WHERE MissionOrgUnitId = '#MissionOrgUnitId#'
					)
					)
					Order by Account

			</cfquery>	 

            <items>
				<cfloop query = "qUsers">
		              <text>#FullName#</text>
				</cfloop>
            </items> 
			
            <items save="1" presence="hidden">
				<cfloop query = "qUsers">
		              <text>#Account#</text>
				</cfloop>
             </items>
         </field>

  
		  		 
	</subform>	 
	
	<subform layout="row" name="HeaderRow3">		 
		 <assist role="TR"/>
	
		  <field name="LogDate" w="#vWidth#mm" h="#vHeight#mm">
                  <ui>
                     <dateTimeEdit/>
                  </ui>
                  <font typeface="Myriad Pro" size="8pt"/>
                  <margin topInset="0.5mm" bottomInset="0.5mm" leftInset="0.5mm" rightInset="0.5mm"/>
                  <para vAlign="middle" hAlign="left"/>
                  <caption reserve="25mm">
                     <para vAlign="middle"/>
                     <value>
                        <text>Date:</text>
                     </value>
                  </caption>				  
                  <value>
                     <date/>
                  </value>
                  <border>
                     <edge/>
                     <corner thickness="0.1778mm"/>
                  </border>
                  <validate formatTest="error">
                     <picture>date.short{}</picture>
                  </validate>				  
         </field>			
		 
         <field name="TransactionType" w="#vWidth#mm" h="#vHeight#mm" presence="hidden">
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
				<text>#URL.TransactionType#</text>
			</value>
         </field>		 

	</subform>	 

	<subform layout="row" name="HeaderRow4">		 
		 <assist role="TR"/>
	
         <field name="Warehouse" w="#vWidth#mm" h="#vHeight#mm" presence="hidden">
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
				<text>#Warehouse#</text>
			</value>
         </field>		

	</subform>	 

		 
</cfoutput>		 