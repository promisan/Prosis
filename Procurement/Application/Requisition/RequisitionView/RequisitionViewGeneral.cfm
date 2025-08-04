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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>administrator</proUsr>
	<proOwn>Hanno van Pelt</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfif url.id neq "WHS">
	<cf_screentop height="100%" jquery="Yes" scroll="Yes" html="No">		
</cfif>

<cfparam name="CLIENT.Sort" default="OrgUnit">

<cfparam name="URL.Sort"             default="Reference">
<cfparam name="URL.View"             default="Hide">
<cfparam name="URL.Lay"              default="Reference">
<cfparam name="URL.annotationid"     default="">
<cfparam name="URL.find"             default="">
<cfparam name="URL.id1"              default="">
<cfparam name="URL.page"             default="1">
<cfparam name="URL.filter"           default="">
<cfparam name="URL.programcode"      default="">
<cfparam name="URL.period"           default="">

<cfif url.filter eq "undefined">
	 <cfset url.filter = "">
</cfif>

<cfquery name="DisplayPeriod" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_Period 
	WHERE  Period='#URL.Period#'
</cfquery>
 
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#' 
</cfquery> 
  
<cfparam name="url.fileNo" default="">    

<cfif url.id neq "LOC">
	<cfset FileNo = round(Rand()*100)>	
	
	<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Requisition#FileNo#">
	<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Requisition_N#FileNo#">

<cfelse>
	<cfset FileNo = url.fileNo>	
</cfif>	

<cfset counted = 0>

<!--- --------------------- --->
<!--- creates the data sets --->
<!--- --------------------- --->


<cfinclude template="RequisitionViewGeneralPrepare.cfm">

<cftry>

	<cfquery name="Check" 
	 datasource="AppsQuery" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     SELECT   count(*) as Total, 
		          SUM(RequestAmountBase) as Amount 
	     FROM     tmp#SESSION.acc#Requisition#fileNo#
	</cfquery>
	 
	<cfcatch>
	 
	 <table align="center"><tr><td class="labelmedium" height="40" align="center"><font color="0080C0">We encountered a problem. Please make your selection again.</font></td></tr></table>
	 <cfabort>
	 
	</cfcatch>
  
 </cftry>
  		
<cfset currrow = 0>
<cfset counted = Check.total>

<cf_tl id="Page" var="1">
<cfset vPage=#lt_text#>

<cf_tl id="Of" var="1">
<cfset vOf= lt_text>

<table width="99%" height="100%" align="center">
     
	  <cfif url.id neq "WHS">
	  	  
		  <tr class="line">
			   <td style="height:30px;font-size:20px;padding-left:5px;padding-right:4px" class="fixlength labellarge"><cfoutput>#Title#</cfoutput>
			   <cfoutput query="DisplayPeriod">
				   #Description#
			   </cfoutput>		
			   </td>				
			   <td align="right">		
			   
					 <cfif url.id eq "WHS">
					 
					 	<!--- nada --->
						
					 <cfelse>	
					 
					 	<cfoutput>
					 
						 <table class="formpadding">
						 <tr>			 			       
						     
						  <td><input type="radio" 
						      name="filter" id="filter" onclick="reloadForm('',view.value,lay.value,sort.value,'me','#URL.fileNo#')" value="me" <cfif url.filter eq "me">checked</cfif>>
						  </td>
						  
						  <td style="cursor:pointer;padding-left:4px" onclick="reloadForm('',view.value,lay.value,sort.value,'me','#URL.fileNo#')" class="labelit">
						  #SESSION.first# #SESSION.last#
						  </td>
						  
						  <td style="padding-left:4px;padding-right:4px">|</td>					      
						  <td style="padding-right:15px" style="cursor: pointer;">
						  						  
							  <cfquery name="CreateBy" 
									datasource="AppsProgram" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT * 
									FROM    System.dbo.UserNames
									WHERE   Account IN (SELECT OfficerUserId 
									                    FROM   userQuery.dbo.tmp#SESSION.acc#Requisition#fileNo#)	
									ORDER BY LastName						  												 				 
							  </cfquery> 						  
							 												  
							  <select name="createby" 
							          id="createby" 
									  style="width:220px"
							          onchange="reloadForm('',view.value,lay.value,sort.value,this.value,'#URL.fileNo#')" 
									  class="regularxl">
		
								  <cfif url.filter eq "me">
								  <option value="me" selected></option>
								  <option value="">[Any requester]</option>
								  <cfelse>
								  <option value="" selected>[Any requester]</option>
								  </cfif>								  
								  <cfloop query="CreateBy">
								  	 <option value="#Account#" <cfif url.filter eq account or (url.filter eq "me" and account eq SESSION.acc)>selected</cfif>>#LastName#</option>
								  </cfloop>
							  
							  </select>
						 
						  </td>
							
						 </tr>
						 </table>	
						 
						 </cfoutput>		 	 
					 
					 </cfif>
					   	   		 			
			  
			    </TD>
		  </tr>
		  		  
	  <cfelse>
	  	   
		 <tr><td align="center" valign="middle">
		  
			  <cf_tableround mode="solidborder" color="silver">
			  	<table cellspacing="0" width="100%" cellpadding="0">
				    <tr><td align="left" valign="middle" style="padding-left:10px" width="1px">			   
					  <cfoutput><img src="#SESSION.root#/images/transfer3.png" height="42" alt="" align="absmiddle" border="0"></cfoutput>
					  </td>
					  <td style="padding-left:10px">
					    <font face="Verdana" size="3" color="gray">Items under Requisition / Order</font> 					   			
						<br>
					    <font face="Verdana" size="1">Lists items that are underin the procurement replensihment process</font> 					   			
				      </td>
				     </tr>
				  </table>
			  </cf_tableround>
			   
		  </td>
		 </tr>
		 <tr><td height="3"></td></tr>
	  	  
	  </cfif>
		  	  
	  <tr style="height:1">  
		  <td colspan="2">
			 <table width="97%" bgcolor="white" align="center">
		   	 <tr>
			 
			 <cfif url.id neq "Loc">
			 
				 <td onclick="maximize('locatebox')">
				 
					<cfset up = "regular">
					<cfset down   = "hide">
					
					<cfoutput>
				 
						<img src="#SESSION.root#/images/up6.png" 
					    id="locateboxMin" alt="" border="0" style="cursor:pointer"
						class="#up#">
		
		    			<img src="#SESSION.root#/images/down6.png" 
					    alt="" style="cursor:pointer" id="locateboxExp"	border="0" 
						class="#down#">		
					
					</cfoutput>	 
				 
				 </td>
			 
			 </cfif>
			 
			 <td width="130" height="38">
			 
			   <cfoutput>
			   <table style="border:1px solid silver"><tr>			   			   
			    <td>
			 
			    <cfparam name="url.find" default="">
				
				<input type     = "text" 
					   name     = "find" 
                       id       = "find"
					   class    = "regularxxl" 
					   style    = "border:0px;padding-left:5px;padding-top:1px;font-size:17px"
					   onKeyUp  = "search()"
					   value    = "#url.find#">
				   
				  </td>
				  
				  <td style="border-left: 1px solid gray;"></td> 
				  <td width="34" align="center" style="cursor:pointer">
				  
				    <cf_space spaces="6">
				  
				    <img src="#SESSION.root#/Images/search.png" 
					     alt="" 
						 height="29"
						 width="29"
						 name="findlocate" id="findlocate"
						 onclick="reloadForm('',view.value,lay.value,sort.value,filter.value,'<cfoutput>#URL.fileNo#</cfoutput>')"
						 border="0" align="absmiddle">
					
				</td></tr>
				</table>
				</cfoutput>
			
			 </td>
			  
			 <td>&nbsp;&nbsp;&nbsp;</td>
												 
			 <td align="right" height="27">
			 
			  <cfif url.id eq "WHS">
						  
				  <select name="sort" id="sort" class="regularxxl" style="font-size:12px;height:20"
					onChange="stockonorder('s')">
			   	     <OPTION value="RequestDescription" <cfif URL.Sort eq "RequestDescription">selected</cfif>><cf_tl id="Order by Description">
					 <OPTION value="RequestQuantity" <cfif URL.Sort eq "RequestQuantity">selected</cfif>><cf_tl id="Order by Quantity">
				  </select>
			  
			  <cfelse>
			  
				  <select name="sort" id="sort" class="regularxxl" 
					onChange="reloadForm('',view.value,lay.value,this.value,'<cfoutput>#URL.filter#</cfoutput>','<cfoutput>#URL.fileNo#</cfoutput>')">
			   	     <OPTION value="Reference" <cfif URL.Sort eq "Reference">selected</cfif>><cf_tl id="Order by RequisitionNo">
					 <OPTION value="ActionStatus" <cfif URL.Sort eq "ActionStatus">selected</cfif>><cf_tl id="Order by Status">				    
				     <OPTION value="RequestDate" <cfif URL.Sort eq "RequestDate">selected</cfif>><cf_tl id="Order by Date">			
					 <OPTION value="RequestQuantity" <cfif URL.Sort eq "RequestQuantity">selected</cfif>><cf_tl id="Order by Quantity">
				 	 <OPTION value="RequestDescription" <cfif URL.Sort eq "RequestDescription">selected</cfif>><cf_tl id="Order by Description">			
				  </select>
				  
				  <input type="hidden" name="lay" id="lay" value="Reference">        
					 
				  <select name="view" id="view" class="regularxxl"
					onChange="reloadForm('',this.value,lay.value,sort.value,'<cfoutput>#URL.filter#</cfoutput>','<cfoutput>#URL.fileNo#</cfoutput>')">
			   	         <OPTION value="Hide" <cfif URL.view eq "Hide">selected</cfif>><cf_tl id="Hide">
					 <OPTION value="Show" <cfif URL.view eq "Show">selected</cfif>><cf_tl id="Show">
				  </select>
			  
			  </cfif>
			 		
		  	</td></tr>
		   </table>
		  
		  </td>
	    </tr>
		
		<cfif url.id neq "Loc" and url.id neq "WHS"> 		  
		  
			<tr style="height:1px">
			<td id="locatebox" name="locatebox" class="regular" colspan="2">
			
				<table width="100%" class="formpadding">
				<tr><td class="line" colspan="3"></td></tr>
				
				<cfif Parameter.EnforceProgramBudget gte "1">
				
					<tr><td style="padding-left:5px"></td>
					<td height="24" width="140" class="labelmedium"><cf_tl id="Program/Project">:</td>
					<td>
					 
						  <cfquery name="Program" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT Pe.Reference,
							       P.ProgramCode,
								   P.ProgramName
							FROM   Program P, ProgramPeriod Pe
							WHERE  P.ProgramCode = Pe.ProgramCode
							AND    Pe.Period = '#URL.Period#'
							AND    P.ProgramCode IN (SELECT ProgramCode 
							                        FROM    Purchase.dbo.RequisitionLineFunding
													WHERE   RequisitionNo IN (SELECT RequisitionNo 
													                          FROM   userQuery.dbo.tmp#SESSION.acc#Requisition#fileNo#)
													)						 
						  </cfquery> 
						
						  <cfoutput>
						  <select name="programcode" id="programcode" size="1" class="regularxl" style="width:300"
							onChange="reloadForm('',view.value,'#url.lay#',sort.value,'#URL.filter#','#URL.fileNo#')">
							<option>
							<cfloop query="Program">
							<option value="#ProgramCode#" <cfif url.programcode eq programcode>selected</cfif>>#Reference# #ProgramName#</option>				
							</cfloop>						
						  </select>	
						  </cfoutput>
						  
						</td></tr>  
					  
					  <cfelse>
					  
						  <input type="hidden" name="programcode" id="programcode">
						  
					  </cfif>									
				
				<tr><td style="padding-left:5px"></td>
				    <td height="24" class="labelmedium"><cf_tl id="Annotation">:</td>
				    <td>
					
						<cf_annotationfilter annotationid="#url.annotationid#" 
						                     onchange="reloadForm('','#url.view#','#url.lay#','#url.sort#','#URL.filter#','#URL.fileNo#')">
									
					</td>
				</tr>	
				
				</table>
					
			</td>
			</tr>  
		
		</cfif>
					
		<tr style="height:10px"><td colspan="2" style="padding-left:10px;padding-right:10px">										 
			<cfinclude template="Navigation.cfm"> 							 
		</td></tr>	
		
		<tr><td colspan="2" style="height:100%;padding-left:10px;padding-right:10px">
				
		<cf_divscroll>
		
			<table width="98%" class="navigation_table">	
				
			<TR class="labellarge line fixrow fixlengthlist">
			    <td height="20"></td>
			    <td colspan="2"><cf_tl id="Classification"></td>		    
			    <td><cf_tl id="Date"></td>
				<TD><cfif URL.ID eq "STA" and URL.ID1 eq "2k"><cf_tl id="Buyer"><cfelse><cf_tl id="Last seen by"></cfif></TD>
			    <td>T</td>
				<td><cfif URL.ID eq "STA"><cf_tl id="#url.lay#"><cfelse><cf_tl id="Status"></cfif></td>
			    <td><cf_tl id="Quantity"></td>
			    <td align="right"><cf_tl id="Amount"><cfoutput>(#APPLICATION.BaseCurrency#)</cfoutput></td>
				<td width="30"></td>
			</TR>
											
				<cfswitch expression="#URL.ID#">
				
					<cfcase value="ORG">			
						<cfinclude template="ListingOrganization.cfm">
					</cfcase>			
					<cfcase value="STA">				
					    <cfinclude template="ListingStatus.cfm">
					</cfcase>
					<cfcase value="LOC">
					    <cfinclude template="ListingStatus.cfm">				
					</cfcase>
					
					<cfdefaultcase>
					    <cfinclude template="ListingStatus.cfm">				
					</cfdefaultcase>			
					
				</cfswitch>
													
			</TABLE>
		
		</cf_divscroll>
		
		</td></tr>
								
		</TABLE>		
		
<cf_dropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Requisition_N#FileNo#">
		
<cfset AjaxOnLoad("doHighlight")>	

<script>
	Prosis.busy('no')
</script>
