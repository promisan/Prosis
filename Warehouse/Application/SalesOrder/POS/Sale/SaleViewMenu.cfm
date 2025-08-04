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
<cfparam name="url.addressid"  default="00000000-0000-0000-0000-000000000000">

<cfset vCellStyle    = "width:50%;min-width:114px;margin-bottom:10px;line-height:24px;padding:1px">
<cfset vWidth        = "170px">
<cfset vHeight       = "75px">
<cfset vFontSize     = "22px">
<cfset vBorderRadius = "5px">
<cfset vBGColor     = "darkGray">

<table border="0" class="formspacing">
  <tr>
  
	<cfoutput>
					
	<td style="#vCellStyle#" align="center" valign="middle">
	
			
			<cf_tl id="Store Items" var="1">								  
			
			<cfset buttonlayout = {
				id            = "buttonday",
				subtext       = "#lt_text#",
				height        = "#vHeight#",
				image	      = "",
				width         = "#vWidth#",
				textsize      = "#vFontSize#", 	
				bgColor	      = "e4e4e4",
				textcolor     = "##000000",
				borderColor   = "##000000",
				borderRadius  = "3px",				
                imageHeight   = "48px",
                imagepos      = "right"}>
                                
			<cfquery name="qImage" 
	  		datasource="AppsMaterials" 
	  		username="#SESSION.login#" 
	  		password="#SESSION.dbpw#">
            	SELECT *                  			
				FROM Ref_ImageClass
				WHERE Target = 1
			</cfquery>				
						
			<cfset link = "#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/addItemSelect.cfm?warehouse=#url.warehouse#&customerid={customeridselect}&customeridinvoice={customerinvoiceidselect}&discount={Discount}&PriceSchedule={PriceSchedule}&currency={currency}&salespersonno={salespersonno}&date={transaction_date}&hour={Transaction_hour}&minu={Transaction_minute}&addressid={addressidselect}&requestNo={RequestNo}">				                                                 
                              						
			<cfif get.SaleMode eq "1"> 	
					
				<cf_tl id="Add" var="1">		
																
				<cf_selectlookup
				    box          = "salelines"
					link         = "#link#"
					button       = "cfbutton"
					buttonlayout = "#buttonlayout#"						
					close        = "No"	
					title        = "#lt_text#"											
					module       = "materials"	
					modal        = "true"			
					formname     = "saleform"
					class        = "itemstock"  				
					filter1      = "warehouse"
					filter1value = "#url.warehouse#"		
					filter2		 = "imageclass"				
					filter2value = "#qImage.Code#"
					des1         = "ItemNo"
                    fontsize     = "#vFontSize#" 
                    fontfamily   = "Arial, Helvetica, sans-serif">	
				
			<cfelse>
							
				<cf_tl id="Add" var="1">
				
				<cf_selectlookup
				    box          = "salelines"
					link         = "#link#"
					button       = "cfbutton"
					buttonlayout = "#buttonlayout#"						
					close        = "No"	
					title        = "#lt_text#"	
                    width        = "#vWidth#"
					module       = "materials"	
					modal        = "true"			
					formname     = "saleform"
					class        = "itemextended"  				
					filter1      = "warehouse"
					filter1value = "#url.warehouse#"	
					filter2		 = "imageclass"					
					filter2value = "#qImage.Code#"
					des1         = "ItemNo"
                    fontsize     = "#vFontSize#" 
                    fontfamily   = "Arial, Helvetica, sans-serif">
			
			</cfif>						
                           
      </td>			
	  															
	  <td style="#vCellStyle#" align="center">
	  				
		<cf_tl id="Sales" var="vSaleLbl">
	   	<cf_tl id="Daily Closing" var="1">
		<cf_button2
                    text         = "#vSaleLbl#" 
                    subText      = "#lt_text#"
                    image        = "Financial.png"  
                    onclick		 = "salesdaytotal()" 	
                    width        = "#vWidth#" 
                    height       = "#vHeight#"
				    bgColor		 = "##f1f1f1"
                    textColor    = "##000000"
                    textSize     = "#vFontSize#"
                    imageHeight  = "42px"
                    imagepos     = "right"
				    borderColor  = "##FFFFFF"
				    borderRadius = "#vBorderRadius#">
                               
     </td>     									
	 
	</tr>
	
	<cfif url.scope eq "POS">
    
	<tr>
          <td style="#vCellStyle#" align="center">	
	 
					<cfset link = "#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/getSalesOrder.cfm?mission=#url.mission#&warehouse=#url.warehouse#&">		
					
					<!---

					<cfif getAdministrator("*") eq "1">
					
					--->
					
						<cf_tl id="sales orders" var="1">
						<cfset buttonlayout = {
							subtext      = "#lt_text#",
							id         	 = "buttonday",
							image        = "Logos/Search.png",
							height		 = "#vHeight#",
							textcolor  	 = "##000000",
							width        = "#vWidth#",
							bgColor		 = "##f1f1f1",
							textsize     = "#vFontSize#",
							borderColor  = "##FFFFFF",
							borderRadius = "#vBorderRadius#",
							imageHeight  = "42px",
							imagepos     = "right"}>

							<cf_tl id="Search" var="1">

							<cf_selectlookup
								box          = "search"
								link         = "#link#"
								button       = "cfbutton"
								buttonlayout = "#buttonlayout#"
								close        = "Yes"
								title        = "#lt_text#"
								module       = "materials"
								formname     = "saleform"
								class        = "salesorder"
								filter1      = "warehouse"
								filter1value = "#url.warehouse#"
								des1         = "BatchId"
								fontsize     = "#vFontSize#"
								width        = "#vWidth#" >
								
					<!---			
					</cfif>
					--->
       </td>
	   <td style="#vCellStyle# padding:5px;" align="center">		
	   						
					<cf_tl id="Register sale" var="1">
					<cf_tl id="New" var="vNewLabel">
					   
					<cf_button2
						text		= "#vNewLabel#" 
						subtext		= "#lt_text#"
						id			= "buttonnew"  						
						textsize	= "#vFontSize#" 
						height		= "#vHeight#"
						width		= "#vWidth#"
						textcolor   = "##000000"
						image		= "New-Request.png"
						borderColor = "##FFFFFF"
						borderRadius= "#vBorderRadius#" 
                        imageHeight  = "38px"
						bgColor		 = "##e4e4e4"
                        imagepos     = "right"
						onclick		= "ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applyCustomer.cfm?warehouse=#url.warehouse#','customerbox')">
									   
     	</td>
		</tr>
		
		<cfelse>
		
		<!---
		<tr><td colspan="2" style="padding:6px"><cf_tl id="Comments">:</td></tr>
		<tr><td colspan="2" style="padding:6px">
		<textarea name="memo" style="width:100%;font-size:14px;height:80px;background-color:C1E0FF"></textarea>
		
		</td></tr>
		--->
		
		</cfif>

       </cfoutput>	
	             
</table>
