<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfoutput>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

	<tr><td colspan="4" style="padding:15px">
	
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">	
	
	     <tr>   
							
		<cfif (PO.OrgUnitVendor eq "" or PO.OrgUnitVendor eq "0") and PO.PersonNo neq "">
		
	        <cf_DialogStaffing>
		
			 <td width="80" class="labelmedium"><font color="808080"><cf_tl id="Employee">:</td>
			 <td height="20" class="labelmedium" colspan="3" style="border:1px solid gray;height:30px;padding-left:5px">
			      				   
				      <cfquery name="Person" 
			          datasource="AppsEmployee" 
		      		  username="#SESSION.login#" 
		        	  password="#SESSION.dbpw#">
		      			    SELECT * 
		        		    FROM   Person
		      				WHERE  PersonNo = '#PO.PersonNo#'
		   			  </cfquery>
					  
					   <cfif person.recordcount eq "0">
					  
					    <b><font color="FF0000">Employee Record missing. Contact administrator</font></b>
					  
					  <cfelse>
					  
						  <b><a href="javascript:EditPerson('#PO.PersonNo#')">
								 <font color="0080FF">#Person.FirstName# #Person.LastName#</font>
							 </a>
						  </b>	  
					  
					  </cfif>    
				   
			   </td>		  	   				
			 		
			<cfelse>
			
				   <td class="labelmedium"><cf_tl id="Vendor">:</td>
				   <td class="labelmedium" style="border:1px solid gray;height:30px;padding-left:5px" colspan="3">
	      				   
				    <cfquery name="Org" 
			          datasource="AppsOrganization" 
		      		  username="#SESSION.login#" 
		        	  password="#SESSION.dbpw#">
		      			    SELECT * 
		        		    FROM   Organization 
		      				WHERE  OrgUnit  ='#PO.OrgUnitVendor#'
		   			</cfquery>
					  
					<cfif org.recordcount eq "0">
					  
						<cfif URL.Mode eq "view">   
					    
					    	<b><font face="Calibri" color="FF0000"><cf_tl id="Vendor Record missing">. <cf_tl id="Contact administrator">.</font></b>
						
						<cfelse>
						
							<table cellspacing="0" cellpadding="0">
							
							<cfoutput>
							 
							<tr>
							<td style="padding-right:3px">  
							   <input type="text"   name="vendororgunitname"    id="vendororgunitname" value="" class="regularxl" size="60" maxlength="60" readonly>
							   <input type="hidden" name="vendororgunitmission" id="vendororgunitmission">
						   	   <input type="hidden" name="vendororgunit"        id="vendororgunit"  value="">							  
							</td>
							<td>
							
							<cfquery name="GetVendor" DataSource="AppsPurchase">
								SELECT TreeVendor 
								FROM   Ref_ParameterMission
								WHERE  Mission='#PO.Mission#'
							</cfquery>						   
							
					    	 <img src="#SESSION.root#/Images/contract.gif" alt="Select Unit" name="img1" 
								  onMouseOver="document.img1.src='#SESSION.root#/Images/button.jpg'" 
								  onMouseOut="document.img1.src='#SESSION.root#/Images/contract.gif'"
								  style="cursor: pointer;" alt="" width="24" height="25" border="0" align="absmiddle" 
								  onClick="selectorgN('#GetVendor.TreeVendor#','Operational','vendororgunit','applyorgunit','','1','modal')">
								  
							</td>
							
							</cfoutput>		
							
							</tr>
							
							</table>
						
						</cfif>
					  
					  <cfelse>
					  
					  	<table>
						<tr class="labelmedium">
						<td style="padding-left:5px">					  
					    <input type="hidden" name="vendororgunit" id="vendororgunit" value="#PO.OrgUnitVendor#">     										  
				        <a href="javascript:viewOrgUnit('#PO.OrgUnitVendor#')"><font color="0080C0">#Org.OrgUnitName#</font></a></b>						
						</td>
						<td>
						<cf_getVendorThreshold purchaseNo="#po.PurchaseNo#" orgunit="#PO.OrgUnitVendor#"> 						
						</td>						
						</tr>
						</table>
					   
					  </cfif> 
					  
					  </td>
		
				</cfif>			
	 
		<tr>
		
		   <td height="20" width="10%" class="labelmedium"><font color="808080"><cf_tl id="Print Format"> :</td>
		   <td width="40%" class="labelmedium" style="border:1px solid gray;height:30px;padding-left:5px">
		  	  	   		   
		    <cfif URL.Mode eq "view">
		   
		     <cfif PO.PrintDocumentId eq "">
			 
			 	System Default
			 
			 <cfelse>
			 			 
		        <cfquery name="Document" 
	         	  datasource="AppsOrganization" 
      			  username="#SESSION.login#" 
        	  	  password="#SESSION.dbpw#">
      			    SELECT * 
		       		FROM   Ref_EntityDocument 
      				WHERE  DocumentId  = '#PO.PrintDocumentId#'
      			  </cfquery>
				  
				<cfif Document.recordcount eq "0">
					System Default
				<cfelse>
					#Document.DocumentDescription#
				</cfif>  
				
			 </cfif>	
			 
			 <input type="hidden" name="printdocumentid" id="printdocumentid" value="#PO.PrintDocumentId#">
			  			   
		   <cfelse>
		   
		       <cfquery name="Document" 
	         	  datasource="AppsOrganization" 
      			  username="#SESSION.login#" 
        	  	  password="#SESSION.dbpw#">
      			    SELECT * 
		       		FROM   Ref_EntityDocument 
      				WHERE  EntityCode   = 'ProcPO'
					AND    DocumentType = 'document'
      			  </cfquery>
		   
		      <select name="printdocumentid" id="printdocumentid"  style="border:0px;width:100%" class="regularxl enterastab">
			 	
			   <option value="">System Default</option>	  
		       <cfloop query="Document">
			     <option value="#DocumentId#" <cfif DocumentId eq PO.PrintDocumentId>selected</cfif>>#DocumentCode# #DocumentDescription#</option>
			   </cfloop>
						  
			  </select>
		   
		    </cfif>		   		      		  			     
						   
		   </td>
		   
		   <cfquery name="Inco" 
	          datasource="AppsPurchase" 
      			  username="#SESSION.login#" 
        	  password="#SESSION.dbpw#">
      			SELECT * 
        		FROM   Ref_IncoTerm 
      		 </cfquery>
			 
			 <cfif inco.recordcount eq "0">
			 
			 	<input type="hidden" name="IncoTerms" id="IncoTerms" value="">
			 
			 <cfelse>
			 
			   <td width="10%" style="padding-left:10px" class="labelmedium"><font color="808080"><cf_tl id="IncoTerms">:</td>
			   <td width="40%" class="labelmedium" style="border:1px solid gray;height:30px;padding-left:5px">
		  		   
			    <cfif URL.Mode eq "view">
			   
			      <cfquery name="Inco" 
		          datasource="AppsPurchase" 
	      		  username="#SESSION.login#" 
	        	  password="#SESSION.dbpw#">
	      			    SELECT * 
			       		FROM   Ref_IncoTerm 
	      				WHERE  Code  ='#PO.Incoterms#'
	      			  </cfquery>
				  
			       #Inco.Description#
				   
			   <cfelse>
			   
			     <cfquery name="Inco" 
		          datasource="AppsPurchase" 
	      		  username="#SESSION.login#" 
	        	  password="#SESSION.dbpw#">
	      			SELECT * 
	        		FROM   Ref_IncoTerm 
	      		 </cfquery>
			   
			      <select name="IncoTerms" id="IncoTerms"  style="border:0px;width:100%" class="regularxl enterastab">
				 	
				   <option>	  
			       <cfloop query="Inco">
				     <option value="#Code#" <cfif Code eq "#PO.Incoterms#">selected</cfif>>#code# #Description#</option>
				   </cfloop>
							  
				  </select>
			   
			    </cfif>		
			
			</cfif>   
		   
		   </td>
		   				
	</tr>
							
	<tr>
	   <td class="labelmedium"><font color="808080"><cf_tl id="Order class">:</td>
	   <td class="labelmedium" style="border:1px solid gray;height:30px;padding-left:5px">
	   			   			   
	       <cfif URL.Mode eq "view">
		   
		      <cfquery name="OrderClass" 
	          datasource="AppsPurchase" 
      			  username="#SESSION.login#" 
        	  password="#SESSION.dbpw#">
      			    SELECT * 
        		    FROM   Ref_OrderClass 
      				WHERE  Code = '#PO.OrderClass#'
					
      			  </cfquery>
			  
		       #OrderClass.Description#
			   
		   <cfelse>
		   
		     <cfquery name="POClass" 
	          datasource="AppsPurchase" 
      		  username="#SESSION.login#" 
        	  password="#SESSION.dbpw#">
      				SELECT  * 
	        		FROM    Ref_OrderClass 
					WHERE   (Mission is NULL or Mission = '#PO.Mission#')
      		 </cfquery>
		   
		      <select name="OrderClass" id="OrderClass"  style="border:0px;width:100%" class="regularxl enterastab">
			 	  
		       <cfloop query="POClass">
			     <option value="#POClass.Code#" <cfif POClass.Code eq PO.OrderClass>selected</cfif>>
				    #POClass.Description#
				 </option>
			   </cfloop>
						  
			  </select>
		   
		    </cfif>
		   
	   </td>
	
	   <td class="labelmedium" style="padding-left:10px" height="20"><font color="808080"><cf_tl id="Order Type">:</td>
	   <td class="labelmedium" style="border:1px solid gray;height:30px;padding-left:5px">
	   			   			   
	       <cfif URL.Mode eq "view">
		   
		      <cfquery name="POType" 
	          datasource="AppsPurchase" 
      		  username="#SESSION.login#" 
        	  password="#SESSION.dbpw#">
      			    SELECT * 
        		    FROM   Ref_OrderType 
      				WHERE  Code  ='#PO.OrderType#'
      		  </cfquery>
			  
		       #POType.Description# <cfif POType.ReceiptEntry eq "9">[<cf_tl id="Invoice Only">]</cfif>
			   
		   <cfelse>
		   
		   <cfquery name="POType" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_OrderType R
				WHERE  Code IN (SELECT Code 
				                FROM   Ref_OrderTypeMission 
							    WHERE  Mission = '#PO.Mission#'
							    AND    Code = R.Code)	
			</cfquery>
			
			<cfif POType.recordcount eq "0">
			
				<!--- show all --->
				
				<cfquery name="POType" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_OrderType R	
				</cfquery>
			
			</cfif>
		   
		      <select name="ordertype" id="ordertype"  style="border:0px;width:100%" class="regularxl enterastab">
								  
		       <cfloop query="POType">
			     <option value="#Code#" <cfif Code eq PO.OrderType>selected</cfif>>#POType.Description#</option>
			   </cfloop>
						  
			  </select>
		   
		    </cfif>
	   </td>
	   </tr>
	   
	   <cfif Parameter.TreeVendor neq "">
	   
	   <tr>
	   <td class="labelmedium" height="20"><font color="808080"><cf_tl id="Standard">:</td>
	   <td class="labelmedium" style="border:1px solid gray;height:30px;padding-left:5px">
	   
	       <cfif URL.Mode eq "view">
		   
		      <cfquery name="Standard" 
	          datasource="AppsPurchase" 
      		  username="#SESSION.login#" 
        	  password="#SESSION.dbpw#">
      			    SELECT * 
        		    FROM   Ref_Standard 
      				WHERE  Code  = '#PO.StandardCode#'
      		  </cfquery>
			  
			   <cfif standard.description eq "">
			   N/A
			   <cfelse>
			   #Standard.Code# #left(Standard.Description,40)# 
			   </cfif>
		      			   
		   <cfelse>
		   
		      <cfquery name="standardlist" 
	          datasource="AppsPurchase" 
      			  username="#SESSION.login#" 
        	  password="#SESSION.dbpw#">
      			    SELECT * 
        		    FROM   Ref_Standard 
      			  </cfquery>
		   
		      <select name="standardcode" id="standardcode"  style="border:0px;width:100%" class="regularxl enterastab">
			   <option value=""></option>							  
		       <cfloop query="standardlist">
			     <option value="#standardlist.Code#" <cfif Code eq PO.StandardCode>selected</cfif>>
				    #Code# #left(Description,40)#
				 </option>
			   </cfloop>						  
			  </select>
		   
		    </cfif>
	   
	   </td>
	   	   	   
	   <td class="labelmedium" style="padding-left:10px" height="20"><font color="808080"><cf_tl id="Systems Contract">:<cf_space spaces="20"></td>
	   <td class="labelmedium" style="border:1px solid gray;height:30px;padding-left:5px">
	   
	    <cfif URL.Mode eq "view">
		   
		      <cfquery name="Program" 
	          datasource="AppsProgram" 
      		  username="#SESSION.login#" 
        	  password="#SESSION.dbpw#">			  
			  	SELECT P.ProgramCode,P.ProgramName,Pe.Period,Pe.Reference,P.ProgramClass
        		FROM   Program P, ProgramPeriod Pe
				WHERE  P.ProgramCode  =  Pe.ProgramCode
      			AND    P.ProgramClass != 'Program'
				AND    P.ProgramCode  = '#PO.ProgramCode#'					
      		  </cfquery>
			  
			  <cf_dialogREMProgram>
			  
			   <cfif Program.ProgramName eq "">
			   
			    N/A
			   
			   <cfelse>
			   
			   <a href="javascript:EditProgram('#Program.ProgramCode#','#Program.Period#','#Program.ProgramClass#')">
			   #Program.Reference# #left(Program.ProgramName,40)#
			   </a>
			   </cfif>
		      			   
		   <cfelse>
		      		   
		      <cfquery name="projectlist" 
	          datasource="AppsProgram" 
      		  username="#SESSION.login#" 
        	  password="#SESSION.dbpw#">
      			    SELECT   P.ProgramCode,
					         P.ProgramName,
						     Pe.Reference 
        		    FROM     Program P, ProgramPeriod Pe
					WHERE    P.ProgramCode   =  Pe.ProgramCode
      				AND      P.Mission       = '#Parameter.TreeVendor#'
					AND      P.ProgramClass != 'Program'
					AND      Pe.OrgUnit      = '#PO.OrgUnitVendor#'													
      		  </cfquery>
			  
			  <!--- other tree to take from header --->
			  
			  <cfif projectlist.recordcount eq "0">
			  			  
			      <cfquery name="org" 
		          datasource="AppsProgram" 
	      		  username="#SESSION.login#" 
	        	  password="#SESSION.dbpw#">
	      			  SELECT *
	        		  FROM   Organization.dbo.Organization
					  WHERE  OrgUnit = '#PO.OrgUnitVendor#'																
	      		  </cfquery>
				  
				  <cfquery name="system" 
		          datasource="AppsProgram" 
	      		  username="#SESSION.login#" 
	        	  password="#SESSION.dbpw#">
				   SELECT   MissionParent 
				   FROM     Organization.dbo.Ref_Mission 
				   WHERE    Mission = '#PO.mission#'
				  </cfquery> 
			  
				  <cfquery name="projectlist" 
		          datasource="AppsProgram" 
	      		  username="#SESSION.login#" 
	        	  password="#SESSION.dbpw#">
				  
	      			    SELECT P.ProgramCode,
						       P.ProgramName,
							   Pe.Reference 
	        		    FROM   Program P, ProgramPeriod Pe
						WHERE  P.ProgramCode = Pe.ProgramCode
	      				AND    P.Mission       = '#system.MissionParent#'
						AND    P.ProgramClass != 'Program'
						AND    Pe.OrgUnit IN (
						                       SELECT OrgUnit 
						                       FROM   Organization.dbo.Organization 
											   WHERE  Mission = '#system.MissionParent#'
											   AND    OrgUnitCode = '#org.OrgUnitCode#'	
											 )	
											 
																								
	      		  </cfquery>			  
			  
			  </cfif>
			  
			  <cfif ProjectList.recordcount eq "0">
			  
			  <select name="programcode" id="programcode"  style="border:0px;width:100%" class="regularxl enterastab">
				<option value="">No System Contracts found</option>				  		      						  
			  </select>
			  
			  <cfelse>
		   
		      <select name="programcode" id="programcode"  style="border:0px;width:100%" class="regularxl enterastab">
				<option value="">N/A</option>				  
		       <cfloop query="projectlist">
			     <option value="#ProgramCode#" <cfif ProgramCode eq PO.ProgramCode>selected</cfif>>
				    #reference# #left(ProgramName,55)#
				 </option>
			   </cfloop>
						  
			  </select>
			  
			  </cfif>
		   
		    </cfif>
	   	   
	   </tr>
	   
	   </cfif>
	   
	   <tr>
		   <td class="labelmedium" width="90"><font color="808080"><cf_tl id="Condition">:</td>
		   <td class="labelmedium" style="border:1px solid gray;height:30px;padding-left:5px">
		   			   			   
		       <cfif URL.Mode eq "view">
			   
			      <cfquery name="Condition" 
		          datasource="AppsPurchase" 
	      			  username="#SESSION.login#" 
	        	  password="#SESSION.dbpw#">
	      			    SELECT * 
	        	    	FROM   Ref_Condition 
	      				WHERE  Code  ='#PO.Condition#'
	      			  </cfquery>
				  
			       #Condition.Description#
				   
			   <cfelse>
			   
			      <select name="POCondition" id="POCondition"  style="border:0px;width:100%" class="regularxl enterastab">
				  
				   <cfquery name="POCondition" 
		          datasource="AppsPurchase" 
	      			  username="#SESSION.login#" 
	        	  password="#SESSION.dbpw#">
	      			    SELECT * 
	        		    FROM   Ref_Condition 
	      			  </cfquery>
				  
			       <cfloop query="POCondition">
				     <option value="#POCondition.Code#" <cfif POCondition.Code eq "#PO.Condition#">selected</cfif>>
					    #POCondition.Description#
					 </option>
				   </cfloop>
							  
				  </select>
			   
			    </cfif>
			   
		   </td>	  
		
		   <td class="labelmedium" style="padding-left:10px"><font color="808080"><cf_tl id="Total">:</td>
		   <td class="labelmedium" id="total" style="border:1px solid gray;height:30px;padding-left:5px">		   
		      <cfinclude template="getPurchaseTotal.cfm">		   			    						
			</td>
				
	    </tr>	
	   
	   <cfif PO.Payroll eq "0">
	  	   
		   <cfquery name="GetCustom" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_CustomFields
			</cfquery>
			
		   <cfif Mode eq "View" and Userdefined1 eq "" and Userdefined2 eq "">
		   
		   <cfelse>
		   
		   <cfif getCustom.PurchaseReference1 neq "" or getCustom.PurchaseReference2 neq "">
		   
			   <tr>
			   
			   <cfif getCustom.PurchaseReference1 neq "">
			   <td class="labelmedium" width="125"><font color="808080">#getCustom.PurchaseReference1#:</td>
			   <td colspan="1" class="labelmedium" style="border:1px solid gray;height:30px;padding-left:5px">
			   			   			   
			       <cfif URL.Mode eq "view">	
				       <cfif UserDefined1 eq "">--<cfelse>#Userdefined1#</cfif>			       		   
				   <cfelse>		   			
			    	   <cfinput type="Text" name="UserDefined1" value="#UserDefined1#" required="No" size="20"  maxlength="30" style="border:0px;width:100%;text-align: left" class="regularxl">		   
				    </cfif>				
				   
			   </td>
			   
			   </cfif>
			   
			   <cfif getCustom.PurchaseReference2 neq "">
				
				   <td width="125" style="padding-left:10px" class="labelmedium"><font color="808080">#getCustom.PurchaseReference2#:</td>
				   <td class="labelmedium" style="border:1px solid gray;height:30px;padding-left:5px">
				   	
					  <cfif URL.Mode eq "view">		   		      			  
					      <cfif UserDefined2 eq "">--<cfelse>#Userdefined2#</cfif>	  		   
					  <cfelse>		   			
				    	 <cfinput type="Text" name="UserDefined2" value="#UserDefined2#" required="No" size="20"  maxlength="30" style="border:0px;width:100%;text-align: left" class="regularxl">		   
					  </cfif>
						
				   </td>
							 
			    </cfif>
				
				</tr>
			
			</cfif>
		 
		 </cfif>
		 
		 <cfif Mode eq "View" and Userdefined3 eq "" and Userdefined4 eq "">
		   
		 <cfelse>
		 		        	 	   
			 <tr>
			 
			   <cfif getCustom.PurchaseReference3 neq "">	
			   <td class="labelmedium" width="125"><font color="808080">#getCustom.PurchaseReference3#:</td>
			   <td colspan="1" style="border:1px solid gray;height:30px;padding-left:5px" class="labelmedium">	   			   			   
			       <cfif URL.Mode eq "view">		   		      			  
				       <cfif UserDefined3 eq "">--<cfelse>#Userdefined3#</cfif>	  		   
				   <cfelse>		   			
			    	   <cfinput type="Text" name="UserDefined3" value="#UserDefined3#" required="No"  maxlength="30" size="20" style="border:0px;width:100%;text-align: left" class="regularxl">		   
				    </cfif>		   
			   </td>
			   </cfif>
			
			   <cfif getCustom.PurchaseReference4 neq "">	
			   <td class="labelmedium" style="padding-left:10px"><font color="808080">#getCustom.PurchaseReference4#:</td>
			   <td class="labelmedium" style="border:1px solid gray;height:30px;padding-left:5px">
			   
				  <cfif URL.Mode eq "view">		   		      			  
				       <cfif UserDefined4 eq "">--<cfelse>#Userdefined4#</cfif>	  			   
				  <cfelse>		   			
			    	   <cfinput type="Text" name="UserDefined4" value="#UserDefined4#" required="No"  maxlength="30" size="20" style="border:0px;width:100%;text-align: left" class="regularxl">		   
				  </cfif>
					
			   </td>
			   </cfif>
			   
			</tr>
			
		</cfif>	
			  		
		<tr>   
		
		<td width="90" class="labelmedium" valign="top" style="height:25px;padding-top:4px">
		
				<a href="javascript:more('address')"><font color="808080"><cf_tl id="Address">:&nbsp;</a>
	
				<img src="#SESSION.root#/Images/icon_expand.gif" alt="" 
					id="addressExp" border="0" class="regular" 
					align="absmiddle" style="cursor: pointer;" 
					onClick="more('address','show')">
							
				<img src="#SESSION.root#/Images/icon_collapse.gif" 
					id="addressMin" alt="" border="0" 
					align="absmiddle" class="hide" style="cursor: pointer;" 
					onClick="more('address','hide')">
							
							
		</td>
		   <td colspan="3" style="border:0px solid gray;height:30px;padding-left:5px">	
			
				  <table width="500" cellspacing="0" class="hide" cellpadding="0" align="left" id="address">
				      <tr><td>
					   <cfinclude template="POViewAddress.cfm"> 
					  </td></tr>	 
				  </table>
				  </td>
		</tr>
		
		<cf_calendarscript>
		
		<cfif PO.PersonNo eq "" and PO.Payroll eq "0">
			   						
		<tr>
		   <td height="21" class="labelmedium" width="90"><font color="808080"><cf_tl id="Shipping date">:</td>
		   <td style="border:1px solid gray;height:30px;padding-left:5px">
		   
		   <table cellspacing="0" cellpadding="0"><tr><td class="labelmedium">
		   			   			   
		       <cfif URL.Mode eq "view">
				  	<cfif ShippingDate eq "">--<cfelse>#dateformat(ShippingDate, CLIENT.DateFormatShow)#</cfif>	  	      			  
			      
			   <cfelse>
			   
			   		<cf_intelliCalendarDate9
							FieldName="ShippingDate" 
							Default="#dateformat(ShippingDate,CLIENT.DateFormatShow)#"
							AllowBlank="True"
							style="text-align:center;border:0px"
							Class="regularxl">	
			   
					   
			    </cfif>
				
				</td>
				
				<td class="labelmedium" style="padding-left:6px;padding-right:3px"><font color="808080">by:</td>
				<td>
							
				<cfif URL.Mode eq "view">
				
				  <cfquery name="Tracking" 
		          datasource="AppsPurchase" 
	      		  username="#SESSION.login#" 
	        	  password="#SESSION.dbpw#">
		      			SELECT * 
		        		FROM   Ref_Transport    
						WHERE Code = '#PO.TransportCode#'  			
	      		  </cfquery>
				
				 <table cellspacing="0" cellpadding="0"><tr><td class="labelmedium">
				  <cfoutput>#Tracking.Description#</cfoutput>
				  </td>
				  <td>&nbsp;&nbsp;</td>
				  <td class="labelmedium">
				  
				  <a href="javascript:potrack('#PO.PurchaseNo#')"><font color="0080C0">[edit]</a>
				  				  
				  </td></tr></table>
				
				<cfelse>			
							
				  <cfquery name="Tracking" 
		          datasource="AppsPurchase" 
	      		  username="#SESSION.login#" 
	        	  password="#SESSION.dbpw#">
		      			SELECT * 
		        		FROM   Ref_Transport      			
	      		  </cfquery>
				  
				    <select name="TransportCode" id="TransportCode" class="regularxl enterastab" style="border:0px;width:100%">
									  
				       <cfloop query="Tracking">
					     <option value="#Code#" <cfif Code eq PO.TransportCode>selected</cfif>>
						    #Description#
						 </option>
					   </cfloop>
							  
				    </select>
					
				</cfif>	
							
				</td></tr></table>
			   
		   </td>
		
		   <td style="padding-left:10px" class="labelmedium"><font color="808080"><cf_tl id="Delivery date">:</td>
		   <td style="border:1px solid gray;height:30px;padding-left:5px">
		   			   			   
		       <cfif URL.Mode eq "view">
			   
			   		<cfif DeliveryDate eq "">--<cfelse>#dateformat(DeliveryDate, CLIENT.DateFormatShow)#</cfif>	 
			       
			   <cfelse>
			   
			   		<cf_intelliCalendarDate9
							FieldName="DeliveryDate" 
							Default="#dateformat(DeliveryDate,CLIENT.DateFormatShow)#"
							AllowBlank="True"
							style="text-align:center;border:0px"
							Class="regularxl">	
			  		   
			    </cfif>
		   </td>
		</tr>		
						
		</cfif>	
		
	</cfif>	
	
	<cfif URL.Mode eq "edit">
				
	<tr>
					   				
		 <td valign="top" style="padding-top:4px" class="labelmedium"><font color="808080"><cf_tl id="Memo">:</td>							
	     <td colspan="3" align="left"  style="border:1px solid gray;height:30px;padding-left:0px">
		 		 					 
		      <textarea style="width:100%;height:44;padding:3px;font-size:12px;border:0px" 
			      class="regular" 
				  rows="1" 
				  name="PORemarks"><cfoutput>#PO.Remarks#</cfoutput></textarea>
		 			   
	   </td>
	</tr>
	
	</cfif>
		
	<cfif PO.Payroll eq "0">
			
	<tr id="custom" class="line">
		<td class="labelmedium" height="21" valign="top" style="width;200px;padding-top:7px"><cf_space spaces="50"><cf_tl id="Custom Fields">:</td>
		<td colspan="3" style="padding-right:30px" style="border:1px solid gray;height:30px;padding-left:5px">
		
			<cfif url.mode eq "Edit">
		
				<cfdiv bind="url:poviewcustom.cfm?mode=#url.mode#&id1=#url.id1#&mission=#po.mission#&type={ordertype}">
			
			<cfelse>
			
			    <cfset url.type = PO.OrderType>
				<cfinclude template="POViewCustom.cfm">
			
			</cfif>	
			
		</td>
	</tr>
		
	</cfif>	
	
	<cfif URL.Mode eq "edit">
	
	<tr>
					   				
		 <td  class="labelmedium" height="20"><font color="808080"><cf_tl id="Attachment">:</td>							
	     <td colspan="3" align="left">
		 
		 	<cf_filelibraryN
				DocumentPath="PurchaseOrder"
				SubDirectory="#URL.ID1#" 	
				Filter=""		
				Box="po#url.id1#"
				Insert="yes"		
				loadscript="yes"	
				Remove="yes"
				width="100%"		
				AttachDialog="yes"
				align="left"
				border="1">			 	
		 			   
	   	</td>
	</tr>
		
	<cfelse>
	
			<cf_fileLibraryCheck
				DocumentPath="PurchaseOrder"
				SubDirectory="#URL.ID1#" 	
				filter="">			
				
			<cfif files gte "1">			
			
			<tr>
							   				
				 <td class="labelmedium" height="21"><font color="808080"><cf_tl id="Attachment">:</td>							
			     <td colspan="3" align="left">
				 
				 	<cf_filelibraryN
						DocumentPath="PurchaseOrder"
						SubDirectory="#URL.ID1#" 	
						filter=""		
						Box="po#url.id1#"
						Insert="no"		
						loadscript="yes"	
						Remove="no"
						width="100%"		
						AttachDialog="yes"
						align="left"
						border="1">					 		
				 			   
			   </td>
			</tr>
			
			</cfif>
	
	</cfif>
													
  </table>
  
  </td></tr>
  
  
  <!--- ------------------------ --->
  <!--- ------------------------ --->
  <!--- additional header fields --->
  <!--- ------------------------ --->
  <!--- ------------------------ --->
  
  <cfif PO.Remarks neq "" and URL.Mode neq "Edit">
      	   
	   <tr><td colspan="2">
		
		 <table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
				
			 <tr>
			     <td height="20" style="cursor: pointer;" onClick="more('memo','show')">
			       <table width="100%">
				    <tr><td width="20" align="center" style="border-right: 0px solid Silver;">
				    
					 <cfoutput>
					
					  <img src="#SESSION.root#/Images/arrowright.gif" alt="" 
						id="memoExp" border="0" class="hide" 
						align="absmiddle">
						
						<img src="#SESSION.root#/Images/arrowdown.gif" 
						id="memoMin" alt="" border="0" 
						align="absmiddle" class="regular">
						
					</cfoutput>	
					
					</td>
					<td style="padding-left:3px" class="labelmedium"><b><cf_tl id="Memo"></b></td>
								
					</tr>
			  	</table>
				</td>
			 </tr>	
			 <tr id="memo" class="regular">		 
				  <td>
				  <table width="100%" cellspacing="0" cellpadding="0" align="center">
				      <tr><td colspan="2" class="line"></td></tr>
				      <tr><td style="padding: 3;" class="labelmedium"><cfoutput>#PO.Remarks#</cfoutput></td></tr>	 
				  </table>
				  </td>
			   </tr>
			   
		</table>
		  
	   </td>
	  </tr>
   		
	</cfif>
				
	<cfquery name="Clause" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
    	    FROM      PurchaseClause 
			WHERE     PurchaseNo = '#URL.ID1#'
	</cfquery> 
						
	<cfif Clause.recordcount neq "0" and mode eq "View">
		
				<tr><td colspan="2">
			
				 <table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
					
				 <tr>
				     <td height="20" style="cursor: pointer;" onClick="more('clause','show')">
				       <table width="100%">
					    <tr><td width="20" align="center">
					    <cfoutput>
						<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
							id="clauseExp" border="0" class="hide" 
							align="absmiddle">
							
							<img src="#SESSION.root#/Images/arrowdown.gif" 
							id="clauseMin" alt="" border="0" 
							align="absmiddle" class="regular">
						</cfoutput>	
						
						</td>
						<td style="padding-left:3px;font-size:16px" class="labelmedium"><cf_tl id="Clauses"></td>									
						</tr>
						
				  	</table>
					</td>
				 </tr>	
				 <tr id="clause" class="regular">		 
					  <td>
					  <table width="100%" cellspacing="0" cellpadding="0" align="center">
					      <tr><td colspan="2" class="line"></td></tr>
					      <tr><td>
						    <cfinclude template="POViewClause.cfm">  
						   </td></tr>	 
					  </table>
					  </td>
				   </tr>
				   
				</table>
			  
		   </td></tr>
      			
		<cfelseif mode eq "Edit">
		
			  <cfquery name="CheckClause" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				SELECT *
				FROM Ref_Clause
			  </cfquery>
			
			  <cfif CheckClause.recordcount neq "0">	
			  
			  <tr><td height="2"></td></tr>
			  
			  <tr><td colspan="2">
			
				 <table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
					
				 <tr>
				     <td height="20" style="cursor: pointer;" onClick="more('clause','show')">
				       <table width="100%">
					    <tr><td width="20" align="center">

					    <cfoutput>
						
							<img src="#SESSION.root#/Images/arrowright.gif" alt="" id="clauseExp" border="0" class="hide" align="absmiddle">							
							<img src="#SESSION.root#/Images/arrowdown.gif" id="clauseMin" alt="" border="0" align="absmiddle" class="regular">
							
						</cfoutput>	
						
						</td>
						<td class="labellarge" style="height:35px;padding-left:3px"><cf_tl id="Select one or more clauses to attached this this purchase" class="message"></td>
									
						</tr>
				  	</table>
					</td>
				 </tr>	
				 
				 <tr id="clause" class="regular">		 
					  <td>
					  <table width="100%" cellspacing="0" cellpadding="0" align="center">					      
					      <tr><td>
						    <cfinclude template="POViewClause.cfm">  
						   </td></tr>	 
					  </table>
					  </td>
				   </tr>
				   
				</table>
			  
		   </td></tr>
									
		   </cfif>	
				
		</cfif>	
			 	 			   	   
		  <cfif PO.ActionStatus lt "3" or Access.recordcount neq "0" or
		  		getAdministrator(PO.mission) eq "1" or
				ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL"> 
			   
			  <cfif URL.Mode eq "edit">
			  		  
				<cf_tl id="Save" var="vSave">
				<tr><td style="padding-left:5px" height="30" colspan="2" class="labelmedium">
				
					<table align="center" cellspacing="0" cellpadding="0" class="formpadding">
					<tr>
					<td>
						<cfif PO.ActionStatus eq "1">
							<cfinclude template="POViewStatus.cfm">
						</cfif>
					</td>
					<td style="padding-left:8px">					
					<input type="submit" name="Save" value="#vSave#" style="width:190;height:26" onclick="Prosis.busy('yes')" class="button10g" >
					</td>
					
					</tr>
					</table>		
																  
				</td></tr>
						
			 <cfelse>	
			 
			    <cfif Access.recordcount neq "0" or <!--- the buyer has been granted access in PurchaseActor --->
				    getAdministrator(PO.mission) eq "1" or					
					ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL">
				
				   <!--- administrator, approver or this is the buyer himself --->
				
				    <tr><td align="center" height="30" colspan="2" class="labelmedium">
					
					<table cellspacing="0" cellpadding="0" class="formpadding">
					<tr><td id="amendbox">
					
					<cfif PO.ActionStatus eq "3" and getAdministrator(PO.mission) eq "1">
						
						<cf_tl id="Amend Purchase Order" var="vAmend">
													
						<input type="button" name="Amend" value="#vAmend#" style="font-size:14px;width:270;height:28" class="button10g" onClick= "amendpurchase()">
					
					<cfelseif getAdministrator(PO.mission) eq "1">
									
							<cf_tl id="Edit Purchase Order" var="vEdit">
								
							 <cfif PO.ActionStatus gt "3">
							 <input type="button" name="Amend" value="#vEdit# [admin]" style="font-size:14px;width:270;height:25" class="button10g" onClick= "reloadForm('edit',sort.value)">												
							 <cfelse>
						 	 <input type="button" name="Amend" value="#vEdit#" style="font-size:14px;width:270;height:25" class="button10g" onClick= "reloadForm('edit',sort.value)">																		
							 </cfif>   							 
											 
					</cfif>		 
							 
					
					</tr>
					</table>		 
									
					</td></tr>
					
				</cfif>
				
			 </cfif>	
		 
		 </cfif>
	 	 
		<!--- check if workflow exists --->
		
		<cfquery name="CheckMission" 
				 datasource="AppsEmployee"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT   *
					 FROM     Organization.dbo.Ref_EntityMission 
					 WHERE    EntityCode     = 'ProcPO'  
					 AND      Mission        = '#PO.Mission#' 
		</cfquery>
			
	 <cfif CheckMission.WorkflowEnabled eq "1">		  	  
		
		  <tr><td colspan="2" style="padding-top:3px">
			
				<table width="99%" style="border:0px dotted silver" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
					<td>	
												
					<cf_ActionListingScript>
				    <cf_FileLibraryScript>
					
					<cfoutput>
			   
					    <cfset wflnk = "POViewWorkflow.cfm">
				   
					    <input type  = "hidden" 
						       id    = "workflowlink_#URL.ID1#"
				    	       name  = "workflowlink_#URL.ID1#" 
					           value = "#wflnk#"> 
							
						<input type="button" 
							   class  = "hide"
						       name   = "workflowlinkprocess_#url.id1#" 
							   id     = "workflowlinkprocess_#url.id1#"
						       onClick= "ColdFusion.navigate('PurchaseStatus.cfm?role=#url.role#&header=#url.header#&purchaseno=#url.id1#','postatus')">
				 
				    	<cfdiv id="#URL.ID1#" bind="url:#wflnk#?ajaxid=#URL.ID1#"/>
					 
					 </cfoutput>
					 
					 </td>
					 </tr>
				 </table>
					
			</td></tr>
			
			<tr><td height="3" id="postatus"></td></tr>
		
	  </cfif>
     
</table>
      
</cfoutput>