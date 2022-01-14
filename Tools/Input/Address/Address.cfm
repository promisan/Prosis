
<cfparam name="Attributes.mode" 	     default="View">
<cfparam name="Attributes.spaces"        default="50">
<cfparam name="Attributes.datasource"    default="appsSystem">
<cfparam name="Attributes.addressid"     default="">
<cfparam name="Attributes.addressscope"  default="Employee">
<cfparam name="Attributes.mission"       default="">
<cfparam name="Attributes.emailRequired" default="Yes">
<cfparam name="Attributes.StyleClass"    default="">

<cfset url.mode = attributes.mode>

<cfoutput>

<cfif attributes.mode eq "View" or attributes.mode eq "Edit">
	
	<cfquery name="Nation" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   #CLIENT.LanPrefix#Ref_Nation
		 ORDER BY Name
	</cfquery>
  	
	<cfquery name="qMission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_Mission
		<cfif attributes.Mission neq "">
		WHERE  Mission = '#attributes.mission#' 
		</cfif>	
	</cfquery>
	
	<cfquery name="getAddress" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Ref_Address
		<cfif attributes.addressid eq "">
		WHERE 1=0
		<cfelse>
		WHERE   AddressId = '#attributes.AddressId#'
		</cfif>	
	</cfquery>	
	
	<cfset row = 0>
	<cfset lat  = "">
	<cfset lng  = "">
			
	<cfloop index="itm" list="#getAddress.Coordinates#" delimiters=",">
		<cfset row = row+1>
		<cfif row eq "1">
		   <cfset  lat = itm>
		<cfelse>
		   <cfset  lng = itm>  		
		</cfif>
	</cfloop>		
			
	<table width="100%" border="0" class="formpadding">
			       
			<TR>
			
		    <td style="padding-top:5px"><cf_space spaces="#attributes.spaces#"></td>
			
			<td width="100%"></td>			
									 										 		 
			     <cfif client.googlemap eq "1">
				 				 
				 	<td rowspan="16" valign="top" align="center" style="padding-top:10px;z-index:10; position:relative;padding-left:3px;padding-right:15px;padding-bottom:2px;min-width:430;min-height:400">								 				
						<cfset maplink = "mapaddress()">	
							
						<cf_mapshow scope	  = "embed" 
									mode	  = "#attributes.mode#" 
									class	  = "enterastab" 
									width	  = "400" 
									height	  = "300" 
									latitude  = "#lat#" 
									longitude = "#lng#"
									country	  = "#getAddress.country#"
									city	  = "#getAddress.AddressCity#"
									address	  = "#getAddress.Address#">							
									
					</td>
					
				<cfelse>
				
					<td align="center">									
						<cfset maplink = "">					
					</td>
					
				</cfif>
							
			</tr>																			
			<TR class="#attributes.styleclass#">
		    <TD style="padding-left:5px"><cf_tl id="Country">: <font color="FF0000">*</font</TD>
		    <TD>
			
			    <cfif url.mode eq "edit"> 
			    
					<cfif getAddress.recordcount eq "0">
					   	<select name="country" id="country" class="enterastab regularxl" required="No" onchange="#maplink#">			
						    <cfloop query="Nation">
								<option value="#Code#" <cfif Code eq qMission.CountryCode>selected</cfif>>#Name#</option>
							</cfloop>
					   	</select>		
					<cfelse>
						<select name="country" id="country" class="enterastab regularxl" required="No" onchange="#maplink#">			
						    <cfloop query="Nation">
								<option value="#Code#" <cfif getAddress.Country eq Code>selected</cfif>>#Name#</option>
							</cfloop>
					   	</select>		
					</cfif>
				
				<cfelse>
				
					<cfquery name="Nation" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   Ref_Nation
						WHERE  Code = '#getAddress.Country#'
					</cfquery>
				
					<b>#Nation.Name#</b>
					
				</cfif>	
				
			</TD>
			</TR>			
								
			<TR class="#attributes.styleclass#">
		    <TD style="padding-left:5px"><cf_tl id="State">:</TD>
		    <TD><cfif url.mode eq "edit"> 
			        <cfinput class="regularxl enterastab" type="Text" name="state" size="10" value="#getAddress.State#" maxlength="20">
				<cfelse>
				    <b>#getAddress.State#
				</cfif>		 
			 </TD>
			</TR>
				
			<TR class="#attributes.styleclass#">
		    <TD style="padding-left:5px"><cf_tl id="City">: <font color="FF0000">*</font></TD>
		    <TD><cfif url.mode eq "edit">
			       <cfinput class="regularxl enterastab" type="Text" onchange="#maplink#" id="addresscity" name="addresscity"  value="#getAddress.AddressCity#" message="Please enter a city name" required="Yes" size="40" maxlength="40">				   
				 <cfelse>
					<b>#getAddress.AddressCity#
				</cfif>  
		    </TD>
			</TR>		
			
			<TR class="#attributes.styleclass#">
		    <TD style="padding-left:5px"><cf_tl id="Address">: <font color="FF0000">*</font></TD>
		    <TD><cfif url.mode eq "edit">
			    	<cfinput class="regularxl enterastab" onchange="#maplink#" type="Text" id="address" name="address" value="#getAddress.Address#" message="Please enter an address" required="Yes" size="50" maxlength="100">							
				<cfelse>
					<b>#getAddress.Address#
				</cfif>	
			</TD>
			</TR>
				
		    <TR class="#attributes.styleclass#">
		    <TD style="padding-left:5px"><cf_tl id="Address additional">:</TD>
		    <TD><cfif url.mode eq "edit">
				<cfinput class="regularxl enterastab" type="Text" name="address2" value="#getAddress.Address2#" message="Please enter an address" required="No" size="50" maxlength="100">
				<cfelse>
					<b>#getAddress.Address2#
				</cfif>
			</TD>
			</TR>
			
			<TR class="#attributes.styleclass#">
		    <TD style="padding-left:5px"><cf_tl id="Postal code">:</TD>
		    <TD>
			
				<cfif url.mode eq "edit">
				
			   		 <cf_textInput
					  form      = "addressentry"
					  type      = "ZIP"
					  mode      = "regularxl"
					  name      = "addresspostalcode"
				      value     = "#getAddress.AddressPostalCode#"
				      required  = "No"
					  size      = "8"
					  maxlength = "8"
					  label     = "&nbsp;"
					  style     = "width:70px;text-align: center;">		
					  
				<cfelse>
					
					<b>#getAddress.AddressPostalCode#
					
				</cfif>		  
					 
		    </TD>
			</TR>
			
		    <TR class="#attributes.styleclass#">
		    <TD style="padding-left:5px"><cf_tl id="Room">:</TD>
		    <TD><cfif url.mode eq "edit">
					<cfinput class="regularxl enterastab" type="Text" name="AddressRoom" value="#getAddress.AddressRoom#" style="text-align: left;" required="No" size="30" maxlength="30">	
				<cfelse>
					<b>#getAddress.AddressRoom#
				</cfif>	
			</TD>
			</TR>
										
			<cfinvoke component = "Service.Access"  
			   method           = "RoleAccess" 
			   Role             = "'WardenOfficer'" 
			   returnvariable   = "WardenAccess">	   
			   
			<cfif WardenAccess neq "GRANTED">  
			
				<input type="hidden" name="cLatitude"   id="cLatitude"   value="#lat#"> 
				<input type="hidden" name="cLongitude"  id="cLongitude"  value="#lng#"> 
				<input type="hidden" name="AddressZone" id="AddressZone" value="">	
							
			<cfelse>
			
				<tr class="#attributes.styleclass#">	  
					<td style="padding-left:5px"><cf_tl id="Latitude">:</td>
					<td>
					<table><tr class="#attributes.styleclass#"><td>
					     <cfif url.mode eq "edit">
							<cfinput class="regularxl enterastab" validate="float" value="#lat#" type="Text" name="cLatitude" size="15" maxlength="20">
						<cfelse>
						<b>#lat#
						</cfif>	
					</td>						
					<td style="padding-left:15px"><cf_tl id="Longitude">:</td>		
					<td style="padding-left:7px"><cfif url.mode eq "edit">
							<cfinput class="regularxl enterastab" validate="float" value="#lng#" type="Text" name="cLongitude" size="15" maxlength="20">
						<cfelse>
						<b>#lng#
						</cfif>	
					</td>		
					</tr></table>
					</td>
				</TR>						
						
				<cfif attributes.mission neq "" and attributes.addressscope eq "Employee">	
				
					<cfquery name = "qAddressZone" datasource = "AppsEmployee"> 
							SELECT * 
							FROM   Ref_AddressZone
							WHERE  Mission = '#attributes.mission#'
					</cfquery>
							
					<cfif qAddressZone.recordcount gte "1">		
										
					<TR class="#attributes.styleclass#">
					    <TD style="padding-left:5px"><cf_tl id="Security zone">:</TD>
					    <TD>
						
							<cfquery name = "PersonAddress" 
								   datasource = "AppsEmployee" 
								   username="#SESSION.login#" 
								   password="#SESSION.dbpw#"> 
								   		SELECT AddressZone
										FROM   PersonAddress
										<cfif getAddress.addressid neq "">
										WHERE  AddressId = '#getAddress.AddressId#'
										<cfelse>
										WHERE  1=0
										</cfif>
							   </cfquery>
						
							<cfif url.mode eq "edit">
												
						   	<select name="AddressZone" required="No" class="regularxl enterastab">
	
								<option value=""></option>
								
							    <cfloop query="qAddressZone">
									<option value="#qAddressZone.Code#" <cfif code eq PersonAddress.AddressZone>selected</cfif>>
									#qAddressZone.Description#
									</option>
								</cfloop>
							
						   	</select>		
							
							<cfelse>			
								
								<cfquery name = "qAddressZone" 
								   datasource = "AppsEmployee" 
								   username="#SESSION.login#" 
								   password="#SESSION.dbpw#"> 
									SELECT * 
									FROM   Ref_AddressZone
									WHERE  Code = '#PersonAddress.AddressZone#'
								</cfquery>
								
								<cfif qAddressZone.recordcount eq "1">
									<b>#qAddressZone.Mission#/#qAddressZone.Description#
								</cfif>
							
							</cfif>
							
						</TD>
					</TR>
					
					<cfelse>
					
						<input type="hidden" name="AddressZone" id="AddressZone" value="">	
							
					</cfif>
					
				<cfelse>
				
						<input type="hidden" name="AddressZone" id="AddressZone" value="">	
					
				</cfif>
			
			</cfif>
				
			<TR class="#attributes.styleclass#">
		    <TD style="padding-left:5px"><cf_tl id="eMail">: <cfif Attributes.emailRequired eq "Yes"><font color="FF0000">*</font></cfif></TD>
		    <TD class="#attributes.styleclass#"><cfif url.mode eq "edit">
			
					<cfinput type="Text" 
					 name="emailaddress"  
				     required="#Attributes.emailRequired#" value="#getAddress.emailaddress#" 
					 message="Please enter a valid eMail address" 
					 validate="email" 
					 size="30" 
					 maxlength="40" 
					 class="regularxl enterastab">
					 
				<cfelse>
					<b>#getAddress.emailaddress#
				</cfif>	 
			</TD>
			</TR>
			
			<TR class="#attributes.styleclass#">
		        <td valign="top" style="padding-left:5px;padding-top:5px"><cf_tl id="Remarks">:</td>
		        <TD>
				
				<cfif wardenaccess eq "GRANTED">
					<cfset ht = "100">
				<cfelse>
					<cfset ht = "100">
				</cfif>		
				
				<cfif url.mode eq "edit">
				<textarea class="regular enterastab" style="padding:3px;font-size:13px;width:97%;height:#ht#" name="Remarks">#getAddress.Remarks#</textarea>
				<cfelse>
				<b>#getAddress.Remarks#
				</cfif>
				</TD>
			</TR>	
									
		</table>			
					
<cfelseif attributes.mode eq "Save">	
	
	<cfif Len(Form.Remarks) gt 600>
	  <cfset remarks = left(Form.Remarks,600)>
	<cfelse>
	  <cfset remarks = Form.Remarks>
	</cfif>  		

	 <cfquery name="getAddress" 
     datasource="#Attributes.datasource#" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   System.dbo.Ref_Address
		 <cfif attributes.addressid eq "">
		 WHERE  1=0
		 <cfelse>
		 WHERE  AddressId = '#attributes.AddressId#'
		 </cfif>		   
	 </cfquery>
	 
	 <cfif CLIENT.googlemap eq "1" and (Form.cLatitude eq "" or Form.cLongitude eq "")>

	 		<cfinvoke component="service.maps.googlegeocoder3" 
	          	method="googlegeocoder3" 
				returnvariable="details">	 
			  
			  <cfquery name="Nation" 
				datasource="#Attributes.datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   System.dbo.Ref_Nation
					WHERE  Code = '#Form.Country#'
			  </cfquery>
			  	
		      <cfif Form.AddressCity eq "">
				 	 <cfinvokeargument name="address" value="#Nation.Name#, #Form.AddressPostalCode#">			 
			  <cfelse>
					 <cfinvokeargument name="address" value="#Nation.Name# #Form.AddressCity# #Form.Address#">			 
			  </cfif>
				  
			  <cfinvokeargument name="ShowDetails" value="false">
			  
			</cfinvoke>	  
	
			<cfset lat = details.latitude>
			<cfset lng = details.longitude>
			
	 <cfelse>
	
			<cfset lat = Form.cLatitude>
			<cfset lng = Form.cLongitude>			 
	 
	 </cfif>
	 	 
	 <cfif getAddress.recordcount eq "0">
	 
		 <cfquery name="InsertAddress" 
	     datasource="#Attributes.datasource#" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     INSERT INTO System.dbo.Ref_Address (
					 AddressId,			
					 AddressScope,					
					 Address,
					 Address2,
					 AddressCity,
					 AddressPostalCode,
					 State,
					 Coordinates,
					 AddressRoom,				 
					 Country,			
					 eMailAddress,							
					 Remarks,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
		      VALUES ('#attributes.AddressId#',	
			          '#Attributes.AddressScope#',
					  '#Form.Address#',
					  '#Form.Address2#',
					  '#Form.AddressCity#',
					  '#Form.AddressPostalCode#',
					  '#Form.State#',
					  '#lat#,#lng#',
					  '#Form.AddressRoom#',				
					  '#Form.Country#',		 
					  '#Form.eMailAddress#',				
					  '#Remarks#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		</cfquery>

	 <cfelse>
	 
	 	 <cfquery name="UpdateContract" 
		   datasource="#Attributes.datasource#" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   UPDATE System.dbo.Ref_Address 
			   SET   Address             = '#Form.Address#',
					 Address2            = '#Form.Address2#',
					 AddressCity         = '#Form.AddressCity#',
			 		 AddressRoom         = '#Form.AddressRoom#',					
					 AddressPostalCode   = '#Form.AddressPostalCode#',
					 Coordinates         = '#lat#,#lng#',
					 Country             = '#Form.Country#',
					 State               = '#Form.State#',					
					 eMailAddress        = '#Form.eMailAddress#',						 
					 Remarks             = '#Remarks#'
			   WHERE AddressId  = '#Form.AddressId#' 
	    </cfquery>
	 
	 
	 </cfif>	
					
</cfif>		

</cfoutput>	