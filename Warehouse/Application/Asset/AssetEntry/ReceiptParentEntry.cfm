
<cf_screentop height="100%" 
	  label="Register Item" 	  
	  scroll="Yes" 
	  html="Yes" 
	  jquery="Yes"
	  line="no"
	  layout="webapp" 	 
	  bannerforce="Yes"
	  banner="red">

<cfparam name="URL.Mission"     default = "">
<cfparam name="URL.Mode"        default = "Purchase">
<cfparam name="URL.ItemNo"      default = "">
<cfparam name="URL.ItemUoMId"   default = "{00000000-0000-0000-0000-000000000000}">
<cfparam name="Form.ItemUoMId"  default = "'#URL.ItemUoMId#'">
<cfparam name="URL.ID"          default = "{00000000-0000-0000-0000-000000000000}">

<cfif Form.ItemUoMId eq "'{00000000-0000-0000-0000-000000000000}'">

	<cf_message message="Please select one or more items" return="back">
	<cfabort>

</cfif>

<cf_calendarscript>

<cfquery name="Parameter" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  	SELECT   *
	FROM     Parameter
</cfquery>

<cfquery name="Parent" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
     SELECT   *
     FROM     Item I, 
	          ItemUoM U, 
		      Ref_Category R
	 WHERE    U.ItemUoMId IN (#preservesinglequotes(FORM.ItemUoMId)#) 
	 AND      I.ItemNo = U.ItemNo
	 AND      I.Category = R.Category  
     ORDER BY ItemDescription
</cfquery>

<cfquery name="MakeList" 
  datasource="appsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT   *
	  FROM     Ref_Make
	  WHERE    Code IN (SELECT Code 
	                    FROM   Ref_MakeCategory 
						WHERE  Category = '#parent.category#')
	  ORDER BY Description
</cfquery>

<cfif MakeList.recordcount eq "0">
	
	<cfquery name="MakeList" 
	  datasource="appsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  SELECT   *
		  FROM     Ref_Make	
		  ORDER BY Description
	</cfquery>

</cfif>

<cfquery name="SourceList" 
 datasource="AppsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   *
 FROM     Ref_Source
 ORDER BY ListDefault DESC, ListOrder 
</cfquery>	


<cf_divscroll height="100%">

<cfif URL.ID eq "{00000000-0000-0000-0000-000000000000}">

    <cfset amount = "#numberformat(parent.standardcost,'__,__.__')#">
	
	<cfif url.mode eq "workorder">
	<cfset rqty = "1">
	<cfelse>
	<cfset rqty = "15">
	</cfif>
	
	<table width="100%" height="100%" class="formpadding">
	
	<tr><td valign="top" height="100%" align="center">
	
	<table width="96%" height="100%" align="center" class="formspacing">
	<tr><td align="center" height="100%">
			
<cfelse>
	
	<cfquery name="Receipt" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Receipt R, PurchaseLineReceipt L 
		 WHERE  R.ReceiptNo = L.ReceiptNo 
		 AND    ReceiptId = '#URL.ID#'
	</cfquery>

    <cfinclude template="ReceiptInfo.cfm">
	
	<cfif Parent.recordcount eq "1">
		<cfset amount = round((#Receipt.ReceiptAmountBase#/#Receipt.ReceiptQuantity#) * 100)>
		<cfset amount = amount/100>
	<cfelse>
		<cfset amount = "">
	</cfif>
	<cfset rqty = "#Receipt.ReceiptQuantity#">
	<table width="98%" align="center" class="formpadding">
	
	<tr><td align="center">
	
</cfif>	

<cfquery name="Check" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_ParameterMission P
	  WHERE  Mission = '#url.mission#'	 
	</cfquery>
	
<cfif Check.receiptLocation eq "">

    <cfoutput>
	<font face="Verdana" size="2" color="FF0000">
		No default Receipt location was set for #url.mission#. Contact your administrator.
	</font>
	</cfoutput>

<cfelse>
	
<cfform action="ReceiptParentEntrySubmit.cfm?Mission=#URL.Mission#&ID=#URL.ID#&Mode=#URL.Mode#" 
		method="POST" 
		style="height:100%"
		name="functionselect" 
		target="result">

<input type="hidden" name="itemUoMId" id="itemUoMId" value="<cfoutput>#Form.ItemUoMId#</cfoutput>">
	
<cfoutput query="Parent">
		
	<table width="98%" align="center" class="formpadding">
	<tr>
	    <td colspan="5" height="20" class="labelmedium2" style="padding-top:5px;padding-left:1px"><b>#ItemDescription#</b></td>
	</tr>
	
	<tr><td height="1" colspan="5" class="linedotted"></td></tr>
	
	<tr><td align="center">
	
	   <table width="100%" cellspacing="0" cellpadding="0" align="right" class="formpadding">
	 
	    <tr>
		<td class="labelmedium" height="20" style="padding-left:0px"><cf_tl id="Make">:<font color="FF0000">*</font></td>
		<td colspan="4">
		
			<cfselect name="Make_#ItemNo#" required="Yes" message="Please select a make" class="regularxl">
			   	<cfloop query="MakeList">
				<option value="#Code#" <cfif Parent.Make eq Code>selected</cfif>>#Description#</option>
				</cfloop>
			</cfselect>
			
		</td>
	    </tr>
		
		<cfif SourceList.recordcount eq "1">
		
			<input type="hidden" value="#SourceList.Code#" name="Source_#ItemNo#" id="Source_#ItemNo#">
		
		<cfelse>
		
						
			<tr>
				<td class="labelmedium" valign="top" style="padding-top:2px"><cf_tl id="Source">:</td>
				<td class="labelmedium">			
							
				<select name="Source_#ItemNo#" id="Source_#ItemNo#" required="No"  class="regularxl">
					<cfloop query="SourceList">
					<option value="#Code#">#Description#</option>
					</cfloop>
				</select>
							
				</td>
				
			</tr>		
		
		</cfif>	
		
		<tr>
			<td height="20" class="labelmedium" style="padding-left:0px"><cf_space spaces="40"><cf_tl id="Description">:<font color="FF0000">*</font></td>
			<td colspan="4">
			
			<cfif URL.ID eq "{00000000-0000-0000-0000-000000000000}">
			
				<cfinput type="Text"
				       name="Description_#ItemNo#"
				       value="#ItemDescription#"
				       required="Yes"
					   message="Please enter a description"
				       visible="Yes"
				       enabled="Yes"		      
				       size="80"
				       maxlength="200"
				       class="regularxl enterastab">
			
			<cfelse>
			
				<cfif Receipt.receiptitem eq "">
				
					<cfinput type="Text"
				       name="Description_#ItemNo#"
				       value="#ItemDescription#"
				       required="Yes"
					   message="Please enter a description"
				       visible="Yes"
				       enabled="Yes"		      
				       size="80"
				       maxlength="200"
				       class="regularxl enterastab">
				
				<cfelse>
				 
					<cfinput type="Text"
				       name="Description_#ItemNo#"
				       value="#Receipt.ReceiptItem#"
				       required="Yes"
					   message="Please enter a description"
				       visible="Yes"
				       enabled="Yes"		      
				       size="80"
				       maxlength="200"
				       class="regularxl enterastab">
				   
				</cfif>   
				
			</cfif>	
			   
			 </td>
	    </tr>
	    
	    <tr>
		<td height="20" class="labelmedium" style="padding-left:0px"><cf_tl id="Model">:</td>
		<td colspan="2"><input type="text" name="Model_#ItemNo#" id="Model_#ItemNo#" value="#parent.model#" size="30" maxlength="40" class="regularxl enterastab"></td>
		<td height="20" class="labelmedium" style="padding-left:10px"><cf_tl id="Manufacturer No">:</td>
		<td colspan="1"><input type="text" name="MakeNo_#ItemNo#" id="MakeNo_#ItemNo#" size="30" maxlength="40" class="regularxl enterastab"></td>
		</tr>
		
		<cfif URL.ID eq "{00000000-0000-0000-0000-000000000000}">
		
		    <tr>
			<td width="15%" class="labelmedium" style="padding-left:0px" height="20"><cf_tl id="Unit value in"> #APPLICATION.BaseCurrency#: <font color="FF0000">*</font></td>
			<td colspan="4">
			<cfinput type="Text" style="text-align:right" class="regularxl enterastab" value="#amount#" name="DepreciationBase_#ItemNo#" message="Please enter a valid amount" validate="float" required="Yes" enabled="Yes" size="15" maxlength="20">
			</td>
		    </tr>
		 			
		</cfif>
		
	    <tr>
		<td height="20" class="labelmedium" style="padding-left:0px"><cf_tl id="Inspection No">:</td>
		<td colspan="2"><input type="text" name="InspectionNo_#ItemNo#" id="InspectionNo_#ItemNo#" size="20" maxlength="20" class="regularxl enterastab"></td>
		<td height="20" class="labelmedium" style="padding-left:10px"><cf_tl id="Inspection date">:</td>
		<td colspan="1">
			 <cf_intelliCalendarDate9
				FieldName="InspectionDate_#ItemNo#" 
				class="enterastab regularxl"
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
				AllowBlank="True">	
		</td>
		</tr>
				
		<cfif VolumeManagement eq "1">
		
			<tr>
			<td height="20" class="labelmedium" style="padding-left:0px"><cf_tl id="Weight in kgs">:</td>
			<td colspan="2"><cfinput type="text" validate="float" name="ItemWeight_#ItemNo#" size="10" maxlength="20" class="regularxl enterastab"></td>
			<td height="20" class="labelmedium" style="padding-left:10px"><cf_tl id="Volume in m3">:</td>
			<td colspan="1"><cfinput type="text" validate="float" name="ItemVolume_#ItemNo#" size="10" maxlength="20" class="regularxl enterastab"></td>
			</tr>
			
		</cfif>   
				
		<cfset mode = url.mode>
				
			<cfset url.mode = "Edit">						
			<cfset Ass      = "#ItemNo#">
			<cfinclude template="CustomFields.cfm">
		
		<cfset url.mode = mode>
			
		<tr><td height="3"></td></tr>
		<tr><td colspan="5">
		
			<table width="95%" align="center" class="formpadding">
			   <tr class="linedotted labelmedium2">
				   <td width="3%"><cf_tl id="No"></td>
				   <td width="1%"></td>
			       <td style="width:15%"><cf_tl id="SerialNo"></td>	
				   <td style="width:10%"><cf_tl id="DecalNo"></td>		  
				   <td style="width:10%"><cf_tl id="Barcode"></td>
				   <td style="width:10%"><cf_tl id="SourceNo"></td>
			       <td style="width:40%"><cf_tl id="Memo"></td>
			   </tr>			   
			  			   
			   <!--- ajax box for runtime validation --->
			   
			   <tr class="hide"><td id="validate"></td></tr>
			   
			   <script language="JavaScript1.2">
			   
			   function set()  {
			  		  
				   se = document.getElementsByName("Item")
				   se1 = document.getElementsByName("Serial")
				   se2 = document.getElementsByName("BarCode")
				   se3 = document.getElementsByName("Memo")
				   
				   var count = 0;
				   while (se[count]) {
			          if (se[count].checked == true) {	   
				        se1[count].disabled = false
					    se1[count].className = "regular"
						se2[count].disabled = false
					    se2[count].className = "regular"
						se3[count].disabled = false
					    se3[count].className = "regular"
					   }
				   count++
				   }
			   
			   }
			   
			   function sel(no,ch) {
			   
				   se1 = document.getElementById("SerialNo"+no)
				   se2 = document.getElementById("BarCode"+no)
				   se3 = document.getElementById("Memo"+no)
				   se4 = document.getElementById("DecalNo"+no)
				   se5 = document.getElementById("SourceNo"+no)
				   
				   if (ch == true) {   
				   
				   	    se1.disabled = false
					    se1.className = "regular enterastab"
						se2.disabled = false
					    se2.className = "regular enterastab"
						se3.disabled = false
					    se3.className = "regular enterastab"	
						se4.disabled = false
					    se4.className = "regular enterastab"	
						se5.disabled = false
					    se5.className = "regular enterastab"	
														
					} else { 
					
					     se1.disabled = true
				         se1.value = ""
					     se1.className = "disabled"
						 se2.disabled = true
						 se2.value = ""
					     se2.className = "disabled"
						 se3.disabled = true
						 se3.value = ""
					     se3.className = "disabled"		
						 se4.disabled = true
						 se4.value = ""
					     se4.className = "disabled"		
						 se5.disabled = true
						 se5.value = ""
					     se5.className = "disabled"			
						 
				   }
			  
			   }		
			   		   
			   </script>
			   
			<cfloop index="itm" from="1" to="#rqty#">
			
			<tr>
				<td class="labelit" style="padding:0px">#itm#.</td>
				
				<cfif Parameter.VerifySerialNo eq "1">
				  <cfset s = "Yes">
				<cfelse>
				  <cfset s = "No">
				</cfif>
				
				<cfif Parameter.VerifyDecalNo eq "1">
				  <cfset d = "Yes">
				<cfelse>
				  <cfset d = "No">
				</cfif>
				
				<cfif Parameter.VerifyBarcode eq "1">
				  <cfset b = "Yes">
				<cfelse>
				  <cfset b = "No">
				</cfif>
				
				<cfif URL.ID neq "{00000000-0000-0000-0000-000000000000}">
				
				    <td>
					<input type="hidden" value="1" name="Item_#ItemNo#_#itm#" id="Item_#ItemNo#_#itm#">
					</td> 
				
					<td style="padding-right:1px">							
	
					<cfinput type="Text" name="SerialNo_#ItemNo#_#itm#"
						   id="SerialNo_#ItemNo#_#itm#"
					       message="Please enter a serialNo" 
						   required="#s#" 
						   visible="Yes" 
						   enabled="Yes" 
						   size="15" 
						   maxlength="30" 
						   class="regularxl enterastab">
						   
						<cfif Parameter.VerifySerialNo eq "1">										
					 		 <font color="FF0000">*</font>					
						</cfif>							   
										
					</td>
						
					<td style="padding-right:1px">
					
					<table cellspacing="0" cellpadding="0"><tr><td>
					
					<cfif Parameter.VerifyDecalNo eq "1">	
						    <cfset validate = "ptoken.navigate('validateEntry.cfm?mission=#url.mission#&box=DecalNo_#ItemNo#_#itm#&field=AssetDecalNo&value='+this.value,'validate')">	
						<cfelse>
							<cfset validate = "">	
						</cfif>
											
					<cfinput type="text" 
					      name="DecalNo_#ItemNo#_#itm#" 
						  id="DecalNo_#ItemNo#_#itm#"
						  message="Please enter a decalno" 
						  required="#d#" 
						  onchange="#validate#"
						  size="15" 
						  maxlength="30" 
						  class="regularxl enterastab">
					
					</td>
					<td>
					<cfif Parameter.VerifyDecalNo eq "1">										
					  <font color="FF0000">*</font>					
					</cfif>		
					
					</td></tr></table>
						
					</td>
								
					<td style="padding-right:1px">
					
					<cfif Parameter.VerifyDecalNo eq "1">	
						    <cfset validate = "ptoken.navigate('validateEntry.cfm?mission=#url.mission#&box=DecalNo_#ItemNo#_#itm#&field=AssetDecalNo&value='+this.value,'validate')">	
						<cfelse>
							<cfset validate = "">	
						</cfif>
						
					<table cellspacing="0" cellpadding="0"><tr><td>	
								
					<cfinput type="text" 
					     name="BarCode_#ItemNo#_#itm#" 
						 id="BarCode_#ItemNo#_#itm#" 
						 message="Please enter a barcode" 
						 required="#b#"
						 onchange="#validate#"
						 size="15" 
						 maxlength="30" 
						 class="regularxl enterastab">
					
					</td>
					<td>					
					<cfif Parameter.VerifyBarcode eq "1">					
					  <font color="FF0000">*</font>
					</cfif>		
					</td></tr></table>
									
					</td>
					
					<td style="padding-right:1px">
						<cfinput type="text" name="SourceNo_#ItemNo#_#itm#" required="No" size="10" maxlength="20" class="regularxl enterastab">
					</td>
					
					<td style="padding-right:1px" align="right">
					<input type="text" name="Memo_#ItemNo#_#itm#" id="Memo_#ItemNo#_#itm#" style="width:100%" maxlength="100" class="regularxl enterastab"></td>
					
				<cfelse>
				
				    <!--- manual entry --->
				
				    <td style="padding-right:1px">
					<input type="checkbox" class="enterastab" value="1" onClick="sel('_#ItemNo#_#itm#',this.checked)" <cfif itm eq "1">checked</cfif> id="Item" name="Item_#ItemNo#_#itm#"></td> 				
					<td style="padding-right:1px">
					
						<cfif Parameter.VerifySerialNo eq "1">	
						    <cfset validate = "ptoken.navigate('validateEntry.cfm?mission=#url.mission#&box=SerialNo_#ItemNo#_#itm#&field=SerialNo&value='+this.value,'validate')">	
						<cfelse>
							<cfset validate = "">	
						</cfif>
					
						<input type="Text"
						  id="SerialNo_#ItemNo#_#itm#" 
						  onchange="#validate#" 
						  style="width:100%;height:23;padding-left:3px"
						  name="SerialNo_#ItemNo#_#itm#" <cfif itm neq "1">disabled class="disabled"<cfelse>class="regularxl enterastab"</cfif> 
						  size="15" 
						  maxlength="20">
						  
				    </td>
											
					<td style="padding-right:1px">
						
						<cfif Parameter.VerifyDecalNo eq "1">	
						    <cfset validate = "ptoken.navigate('validateEntry.cfm?mission=#url.mission#&box=DecalNo_#ItemNo#_#itm#&field=AssetDecalNo&value='+this.value,'validate')">	
						<cfelse>
							<cfset validate = "">	
						</cfif>
					
					   <input type="text" 
					          id="DecalNo_#ItemNo#_#itm#" 
							  onchange="#validate#"
							  style="width:100%;height:23;padding-left:3px"
							  name="DecalNo_#ItemNo#_#itm#" <cfif itm neq "1">disabled class="disabled" <cfelse>class="regularxl enterastab"</cfif> 
							  size="15" 
							  maxlength="20">
							  					
					</td>
								
					<cfif Parameter.VerifyBarcode eq "1">
					     <cfset s = "Yes">
					<cfelse>
					     <cfset s = "No">
					</cfif>
					
					<td style="padding-right:1px">
					
						<cfif Parameter.VerifyBarCode eq "1">	
						    <cfset validate = "ptoken.navigate('validateEntry.cfm?mission=#url.mission#&box=BarCode_#ItemNo#_#itm#&field=AssetBarCode&value='+this.value,'validate')">	
						<cfelse>
							<cfset validate = "">	
						</cfif>
										
						<input type="text"
						     id="BarCode_#ItemNo#_#itm#" 
							 name="BarCode_#ItemNo#_#itm#" 
							 style="width:100%;height:23;padding-left:3px"
							 onchange="#validate#"							 
							 <cfif itm neq "1">disabled class="disabled" <cfelse>class="regularxl enterastab"</cfif> size="10" 
							 maxlength="20">
							 
					</td>
					
					<td style="padding-right:1px">
					
					    <input type="text" 
						  id="SourceNo_#ItemNo#_#itm#" 
						  style="width:100%;height:23;padding-left:3px"
						  name="SourceNo_#ItemNo#_#itm#" <cfif itm neq "1">disabled class="disabled" <cfelse>class="regularxl enterastab"</cfif> 
						  size="15" 
						  maxlength="20">
						
					</td>
					
					<td style="padding-right:1px">
					
						<input type="text" 
						 id="Memo_#ItemNo#_#itm#" 
						 style="width:100%;height:23;padding-left:3px"
						 name="Memo_#ItemNo#_#itm#" <cfif itm neq "1">disabled class="disabled"<cfelse>class="regularxl enterastab"</cfif> 						
						 style="width:100%"
						 maxlength="100">
						
					</td>
																
				</cfif>
				
			</tr>
			
			</cfloop>
			
			</table>
			
		</td></tr>
		
		<cfset save = 1>
		
		<!--- select account code for contract booking --->
		
		<cf_verifyOperational 
			 datasource="appsMaterials"
		     module="Accounting" 
		     Warning="No">
				 				 			 			 
		<cfif ModuleEnabled eq "1">
						
			<tr><td class="line" colspan="6"></td></tr>				
			<tr>
			<td class="labelmedium2">Ledger Posting</td>
			<td colspan="5">
			
			<table width="100%" class="formpadding">
					  							
				 <td style="padding-left:5px" class="labelmedium" height="22"><cf_tl id="Stock Account">:</td>
				 <td class="labelmedium">
					
						    <cfquery name="Account" 
							    datasource="appsMaterials" 
							    username="#SESSION.login#" 
							    password="#SESSION.dbpw#">
								    SELECT    R.*
								    FROM      Ref_CategoryGledger S, Accounting.dbo.Ref_Account R
									WHERE     S.Category = '#Category#'
									AND       (S.Mission  = '#url.mission#' or S.Mission is NULL) 
									AND       S.Area = 'Stock' 
									AND       S.GLAccount = R.GLAccount
									ORDER BY  Mission DESC					
							 </cfquery>
							 
							 <cfif account.recordcount eq "0">
								 <font color="FF0000">No stock account defined</font>
								 <cfset save = 0>
							 </cfif>
							 
							 <b>#Account.GLAccount# #Account.Description#</b>
					
				</td> 				
				<td class="labelmedium" style="padding-left:5px"><cf_tl id="Contra-account">:</td>
			
			    <td>
			
			        <cfquery name="Account" 
					    datasource="appsMaterials" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						    SELECT    DISTINCT R.GLAccount,R.Description, S.Area
						    FROM      Ref_CategoryGledger S, Accounting.dbo.Ref_Account R
							WHERE     S.Category = '#Category#'
							AND       (S.Mission  = '#url.mission#') 
							AND       S.Area != 'Stock' 
							AND       S.GLAccount = R.GLAccount											
					</cfquery>
					 
					<cfif Account.recordcount eq "0">
					 
						    <cfquery name="Account" 
						    datasource="appsMaterials" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
							    SELECT    DISTINCT R.GLAccount,R.Description, S.Area
							    FROM      Ref_CategoryGledger S, Accounting.dbo.Ref_Account R
								WHERE     S.Category = '#Category#'
								AND       S.Mission is NULL 
								AND       S.Area != 'Stock' 
								<cfif URL.ID neq "{00000000-0000-0000-0000-000000000000}">
								AND       S.Area = 'Receipt'
								</cfif> 
								AND       S.GLAccount = R.GLAccount											
						    </cfquery>					 
					 
					</cfif>
					 
					<cfif URL.ID eq "{00000000-0000-0000-0000-000000000000}">
					 					 
					 <select name="ReceiptAccount" id="ReceiptAccount" class="regularxl">
						 <cfloop query="Account">									 
						 	<option value="#GLAccount#" <cfif area eq "InitialStock">selected</cfif>>#Area#: #GLAccount# #Description#</option>
						 </cfloop>
					 </select>
					 
					<cfelse>
					 
					  <select name="ReceiptAccount" id="ReceiptAccount" class="regularxl">
						 <cfloop query="Account">									 
						 	<option value="#GLAccount#" <cfif area eq "Receipt">selected</cfif>>#Area#: #GLAccount# #Description#</option>
						 </cfloop>
					 </select>
					 
					</cfif>			
			
			    </td>
			</tr>
			
			</table>
			
			</td>
			
			</tr>
				
		</cfif>
		
		</TABLE>
	</TD></TR>		
	
	</table>		
			
</cfoutput>
	
<cfoutput>
	
	<cfif URL.ID eq "{00000000-0000-0000-0000-000000000000}">
	
			<script>
			function search() {			
				ptoken.location('../Item/ItemSearchMaster.cfm?mode=#url.mode#&mission=#url.mission#')		
			}
			</script>
		
		</td></tr>
		<tr><td height="1" class="linedotted"></td></tr>
	   	<tr><td height="27" align="center">
		<cf_tl id="Return" var="1">
		<input type="button" name="Submit" id="Submit" class="button10g" style="width:120;height:23;font-size:13px" value="#lt_text#" onclick="search()">
		<cfif save eq "1">
		<cf_tl id="Register" var="1">		
		<input type="submit" name="Submit" id="Submit" class="button10g" style="width:120;height:23;font-size:13px" value="#lt_text#">
		</cfif>
		</td></tr>
		
		</td></tr></table>
	
	<cfelse>
		
		<table width="100%">
		<tr><td height="1" class="linedotted"></td></tr>
		<tr><td height="27" align="center">
		<cf_tl id="Back" var="1">	
		<input type="button" name="Submit" id="Submit" class="button10g" style="width:120;height:23;font-size:13px" value="#lt_text#" onclick="ptoken.location('ReceiptParentSelect.cfm?id=#url.id#')">
		<cf_tl id="Register" var="1">	
		<cfif save eq "1">		
		<input type="submit" name="Submit" id="Submit" class="button10g" style="width:120;height:23;font-size:13px" value="#lt_text#">
		</cfif>
		</td></tr>
		</table>
		
	</cfif>
	
	</cfoutput>
	
</cfform>	

</cfif>

</td>
</tr>
	
</table>	

</cf_divscroll>

<cf_screenbottom layout="webapp">  