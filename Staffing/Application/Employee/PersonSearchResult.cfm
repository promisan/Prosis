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

<cf_screentop height="99%" jquery="Yes" scroll="No" html="No">

<cfparam name="client.PersonSearchLayout" default="">

<cfparam name="URL.Sort"   default="LastName">
<cfparam name="URL.Lay"    default="#client.PersonSearchLayout#">
<cfparam name="URL.Mode"   default="">
<cfparam name="url.page"   default="1">
<cfparam name="url.height" default="600">
<cfparam name="url.fileno" default="">
<cfparam name="fileno"     default="#url.fileno#">

<cfset client.PersonSearchLayout = url.lay>

<cfif not IsNumeric(URL.height)>
    <cfset url.height = 600>
</cfif>

<cfoutput>
	
	<script language="JavaScript">
	
		function list(page) {
		    Prosis.busy('yes')
	    	srt = document.getElementById("sort").value
			lay = document.getElementById("layout").value
			mde = document.getElementById("searchmode").value
	    	ptoken.location('PersonSearchResult.cfm?missionselect=#missionselect#&fileno=#fileno#&height='+document.body.offsetHeight+'&page=' + page + '&sort=' + srt + '&Lay=' + lay+ '&mode=' + mde);
		}
	
		function mysearch() {  			
		    ptoken.location('PersonSearch1.cfm?height='+document.body.offsetHeight) 
		}

		function workflowaction(personno, mission) {
			if ($('##row'+personno).is(':visible')) {
				$('##line'+personno).html('');
				$('##row'+personno).hide();
			} else {
				ptoken.navigate('PersonSearchAction.cfm?personno='+personno+'&mission='+mission,'line'+personno, function(){
					$('##row'+personno).show();
				});
			}
		}
		
	</script>	

</cfoutput>

<cftry>

	<cfquery name = "SearchTotal" 
		datasource    = "AppsQuery" 
		username      = "#SESSION.login#" 
		password      = "#SESSION.dbpw#">
		SELECT count(*) as total 
	    FROM #SESSION.acc#Person_#fileno# P
	</cfquery>

	<cfcatch>	
		<cflocation addtoken="No" url="PersonSearch1.cfm">		
	</cfcatch>

</cftry>

<cfif url.lay eq "Contract">
	<cfset rows    = ceiling((url.height-160)/50)>
<cfelse>
    <cfset rows    = ceiling((url.height-160)/25)>
</cfif>	

<cfset cpage   = url.page>
<cfset first   = ((cpage-1)*rows)+1>
<cfset top     = cpage*rows>
<cfif top lt "1">
	<cfset top eq "1">
</cfif>	
<cfset pages   = Ceiling(SearchTotal.total/rows)>

<cfif  pages lt "1">
	   <cfset pages = '1'>
</cfif>

<cftry>

<cftransaction isolation="READ_UNCOMMITTED">

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   TOP #top# * 
    FROM     #SESSION.acc#Person_#fileno# P LEFT OUTER JOIN System.dbo.Ref_Nation N ON P.Nationality = N.Code
    ORDER BY P.#URL.Sort# #CLIENT.Collation# 
</cfquery>

</cftransaction>

<cfcatch>

		<table align="center"><tr><td align="center" height="300" class="labelmedium">A problem occurred executing your request. <a href="javascript:history.back()"><font color="0080C0">Please try again.</font></a></td></tr></table>
		<cfabort>
		
</cfcatch>

</cftry>

<cf_dialogStaffing>
<cf_dialogPosition>

<table width="96%" style="height:98.5%" align="center" class="formpadding">

<tr>
  <td style="height:100%">

	<table width="100%" style="height:100%">
	  <tr class="line">
	    <td style="height:46;padding-left:5px">
		
			<table>
			<tr>
			<cfif url.mode eq "1">
			<td class="labellarge" style="font-weight:200;font-size:31px;padding-left:4px"><cf_tl id="On Board"></td>
			<cfelseif url.mode eq "2">
			<td class="labellarge" style="font-weight:200;font-size:31px;padding-left:4px"><cf_tl id="No Portal access"></td>
			<cfelseif url.mode eq "9">
			<td class="labellarge" style="font-weight:200;font-size:31px;padding-left:4px"><cf_tl id="Expiring Contracts"></td>
			<cfelseif url.mode eq "5">
			<td class="labellarge" style="font-weight:200;font-size:31px;padding-left:4px"><cf_tl id="Happy Birth Day"></td>
			<cfelse>
			<td class="labellarge" style="font-weight:200;font-size:31px;padding-left:4px"><cf_tl id="Employee Search"></td>
			</cfif>		
			<td style="padding-left:14px;font-size:14px;padding-top:5px" class="labelit">
				<a href="javascript:mysearch()"><cf_tl id="New search">
				</a>
			</td>
			
			</tr>
			</table>
			
		</td>
		
		<td align="right" style="padding-right:4px;padding-top:14px">
		
		<cfoutput>
		<input type="hidden" id="searchmode" value="#url.mode#">
		</cfoutput>
		
		 <table class="formspacing">
		 <tr>
		 <td>
		 <select name="layout" id="layout" size="1" style="border:0px;background-color:f1f1f1" class="regularxxl" onChange="Prosis.busy('yes');list(page.value)">
		     <OPTION value="Listing"  <cfif URL.Lay eq "Listing">selected</cfif>><cf_tl id="Listing">
			 <option value="Contract" <cfif URL.Lay eq "Contract">selected</cfif>><cf_tl id="Contract">
	     </SELECT>
		 </td>
		 
		 <td>	
		 <select name="sort" id="sort" size="1" class="regularxxl" style="border:0px;background-color:f1f1f1" onChange="Prosis.busy('yes');list(page.value)">
		     <OPTION value="LastName" <cfif URL.Sort eq "LastName">selected</cfif>><cf_tl id="Sort by Lastname">
			 <option value="Firstname" <cfif URL.Sort eq "FirstName">selected</cfif>><cf_tl id="Group by Firstname">
		     <OPTION value="IndexNo" <cfif URL.Sort eq "IndexNo">selected</cfif>><cf_tl id="Group by IndexNo">
			 <OPTION value="Nationality" <cfif URL.Sort eq "Nationality">selected</cfif>><cf_tl id="Sort by Nationality">
	     </SELECT>
		 </td>
	
		 <td>
		 <cfif pages gte "2">
		 	 
		 <select name="page" id="page" class="regularxxl" size="1" style="border:0px;background-color:f1f1f1" onChange="Prosis.busy('yes');list(this.value)">
		     <cfloop index="Item" from="1" to="#pages#" step="1">
		        <cfoutput><option value="#Item#"<cfif cpage eq "#Item#">selected</cfif>><cf_tl id="Page"> #Item# <cf_tl id="of"> #pages#</option></cfoutput>
		     </cfloop>	 
		 </select>
		 
		 <cfelse>
		 
		 	<input type="hidden" id="page" name="page" value="1">
		 </cfif>
		 
		 </td></tr>
		 </table>   	
		 
	    </TD>
	  
	  </tr>
	   
	  <tr><td colspan="2" align="center" style="padding:4px">
			  <cf_pagenavigation cpage="#cpage#" pages="#pages#">
	  </td></tr>
	  
	  <cfoutput>
	  <tr class="line"><td class="labellarge" style="height:34px;font-size:18px;padding-left:10px" colspan="2"><cfif missionselect neq "">#missionselect#:</cfif><font color="FF0080"><cf_tl id="Your search criteria resulted in"><b>#SearchTotal.Total#</b><cfif SearchTotal.total eq "1"><cf_tl id="match"><cfelse><cf_tl id="matches"></cfif></td></tr>
	  </cfoutput>
	     
	   <td height="100%" width="100%" colspan="2" valign="top" style="min-width:500">
	   
		   	<cf_divscroll>
	
			<table width="98%" border="0" cellspacing="0" cellpadding="0" class="navigation_table" align="center">
			
			<TR class="labelmedium line fixrow fixlengthlist">
			
			    <TD></TD>
				<TD></TD>
				
			    <TD><cf_tl id="Name"></TD>	
				<!---		
			    <TD style="min-width:90px"><cf_tl id="First name"></TD>
				<TD style="min-width:70px"><cf_tl id="Middle"></TD>
				--->
				<td><cf_tl id="No"></td>
				<TD><cf_tl id="IndexNo"></TD>		    
			    <td></td>
			    <TD><cf_tl id="DOB"></TD>
				<TD><cf_tl id="Nationality"></TD>
			    <TD><cf_tl id="Entity"></TD>	
				<TD></TD>
				<TD><cf_tl id="Level"></TD>		
			    <TD><cf_tl id="Post title"></TD>	
				<TD><cf_tl id="Expiry"></TD>		
			    <TD><cf_tl id="Source"></TD>
			
			</TR>
			
			<cfif searchresult.recordcount eq "0">
			
			<tr><td colspan="15" align="center" style="height:40px" class="labellarge"><cf_tl id="There are no records to show in this view"></td></tr>
			
			</cfif>
			
			<cfset currrow = 0>   
				
			<cfoutput query="SearchResult" group="#URL.Sort#" startrow="#first#">
			
			   <cfif currentrow-first lt rows>		
			 
			   <cfswitch expression = URL.Sort>
			     <cfcase value = "Nationality">
				 <tr bgcolor="f6f6f6">
			     	<td colspan="15" class="labelmedium" style="padding-left:10px"><b>#Name#</b></font></td>
				 </tr>
			     </cfcase>
			   </cfswitch>
					   
			   </cfif>
			   
			   <cfoutput>
			   		   
			   <cfif currentrow-first lt rows>		
				   
				   <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('e7e7e7'))#" 
				       class="navigation_row  fixlengthlist labelmedium <cfif URL.Lay neq 'Contract'>line</cfif>" style="height:23px">
					   	
					   <cfif assignment gte "1">
					   <td bgcolor="FF7837">&nbsp;</td>
					   <cfelse>
					   <TD align="center"></TD>
					   </cfif>	
					   <td align="center" style="padding-top:2px" class="navigation_action" onclick="EditPerson('#PersonNo#')">			   
					     <cf_img icon="select">						     
					   </td>		
					  
					   <TD title="#fullname#">#FullName#</TD>				  
					   <!---
					   <TD style="padding-left:1px">#FirstName#</TD>
					   <TD style="padding-left:1px">#MiddleName#</TD>
					   --->
					   <TD>#PersonNo#</TD>
					   <TD>#IndexNo#</TD>				   
					   <TD>#Gender#</TD>
					   <TD>#DateFormat(BirthDate, CLIENT.DateFormatShow)#</TD>
					   <TD>#Name#</TD>
					   <TD>#Mission#</TD>	
					   <TD align="center">
					   <cfif pendingAction gte "1">
					     <cf_img icon="open" onclick="workflowaction('#personNo#','#Mission#')">	 				   
					   </cfif>		
					   </TD>		
					   <TD>#ContractLevel#</TD>		   
					   <TD title="#FunctionDescription#">
					   <cfif PositionNo neq ""><a href="javascript:EditPosition('','','#PositionNo#')">#FunctionDescription#</a></cfif></TD>	
					   <TD>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</TD>			   
					   <TD>#Source#</TD>
				   </TR>
				      
				   <cfif URL.Lay eq "Contract">			   
				   	
					   <cftransaction isolation="READ_UNCOMMITTED">
				   
					   <cfquery name="Contract" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   TOP 1 * 
						    FROM     PersonContract
							WHERE    PersonNo = '#SearchResult.PersonNo#'
							and      ActionStatus <> '9'
							ORDER BY DateEffective DESC
						</cfquery>
						
						</cftransaction>
						
						 <cfif contract.recordcount eq "0">
						 	<tr bgcolor="ffffff" class="navigation_row_child labelit">
							   <td></td><td></td><td style="border-bottom :1px solid silver" colspan="11" class=" line labelit"><font color="FF8080">No contract information found</font></td>
							 </tr>
						 </cfif>
					
					     <cfloop query="Contract">
					   
						     <tr class="navigation_row_child labelmedium line">
							     <td></td>
								 <td></td>							 
							     <td style="padding-left:3px;border-bottom :1px solid silver" bgcolor="ffffbf">#Mission#</td>  
								 <td style="border-bottom :1px solid silver" bgcolor="ffffbf">#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
							     <td style="border-bottom :1px solid silver" bgcolor="ffffbf">#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</td>
							     <TD style="border-bottom :1px solid silver" bgcolor="ffffbf" colspan="5">#ContractType#  #ContractFunctionDescription#</TD>
							     <TD style="border-bottom :1px solid silver" bgcolor="ffffbf">#SalarySchedule#</TD>
							     <td style="border-bottom :1px solid silver" bgcolor="ffffbf" colspan="5" >#ServiceLocation# &nbsp;#ContractLevel#/#ContractStep#</td>
						     </tr>
					     
					   </cfloop> 
				  
				   </cfif>
				   
				   <tr id="row#PersonNo#" class="hide">			   		   
				   <td></td>
				   <td colspan="13" id="line#PersonNo#" style="border-left:1px solid silver"></td>
				   </tr>
				     			
				</cfif>
			   
			   </cfoutput>
			     
			</CFOUTPUT>
	
		</TABLE>
		
		</cf_divscroll>
		
		</td>
		</tr>
		
	</table>
</td>
</tr>
</table>

<cf_screenbottom>

<cfset AjaxOnLoad("doHighlight")>	

