
<cf_screentop height="100%" scroll="No" html="No" jquery="Yes">

<cfparam name="CLIENT.Sort" default="ActionDate">
<cfif CLIENT.Sort neq "ActionDate" or
      CLIENT.Sort neq "LastName" or
	  CLIENT.Sort neq "OfficerLastName">
      <cfset deleted = deleteClientVariable("Sort")>
</cfif>   

<cfparam name="CLIENT.Sort" default="ActionDate">
<cfparam name="URL.Sort" default="#CLIENT.Sort#">
<cfparam name="URL.page" default="1">
<cfparam name="URL.Lay" default="Listing">

<cfset orderby = "E.LastName, E.FirstName">
 
<cfswitch expression="#URL.Sort#">

  <cfcase value="LastName">
      <cfset orderby = "E.LastName, E.FirstName">
  </cfcase>
  <cfcase value="OfficerLastName">
      <cfset orderby = "A.OfficerLastName, A.OfficerFirstName">
  </cfcase>
   <cfcase value="ActionDate">
      <cfset orderby = "A.ActionDate">
  </cfcase>
    
</cfswitch> 

<cfquery name="Default" 
datasource="AppsOrganization" 
maxrows=1 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT MandateNo 
   FROM   Ref_Mandate
   WHERE  Mission = '#URL.Mission#'
   AND    MandateDefault = 1
   </cfquery>

<cfif Default.recordCount eq 1>
   <cfparam name="URL.ID3" default="#Default.MandateNo#">
<cfelse>
   <cfparam name="URL.ID3" default="0000">   
</cfif>   

<cfparam name="URL.Mandate" default="#URL.ID3#">

<cfquery name="Current" 
datasource="AppsOrganization" 
maxrows=1 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT *
   FROM   Ref_Mandate
   WHERE  Mission = '#URL.Mission#'
   AND    MandateNo = '#URL.Mandate#'
</cfquery>

 <cfquery name="Mandate" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT  * 
   FROM    Ref_Mandate
   WHERE   Mission = '#URL.Mission#'
   ORDER BY MandateNo DESC
   </cfquery>
   
<cfoutput>
	
	<script>
	
	function reloadForm(page,sort,layout,mandate,detail) {
	   mis = document.getElementById("mission").value
	   Prosis.busy('yes') 
	   ptoken.location("TransactionViewGeneral.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ID4=#URL.ID4#&Page=" + page + "&Sort=" + sort + "&Lay=" + layout + "&Mandate=" + mandate + "&Mission=" + mis + "&detail=" + detail);
	}
	
	function processaction(act,des,doc,src) {
	if (confirm("Do you want to " + des + " this transaction ?")) {
	    ptoken.open("TransactionProcess.cfm?ID=#URL.ID#&ID1=#URL.ID1#&mission=#URL.mission#&mandate=#URL.mandate#&ID3=#URL.ID3#&ID4=#URL.ID4#&Page=#url.page#&sort=#url.sort#&lay=#url.lay#&act=" + act + "&doc=" + doc + "&src=" + src, "_self")
	  	}
	}
	
	</script>	

</cfoutput>

<cf_dialogPosition>


<cfset cond = "">

<cfswitch expression="#URL.ID#">

	<cfcase value="CDE">
	   <cfif URL.ID1 neq "">
	      	<cfset cond = "AND A.ActionCode = '#URL.ID1#'">
	   </cfif>
	</cfcase>
	
	<cfcase value="TPE">
	        <cfset cond = "AND A.Posttype = '#URL.ID1#'">
	</cfcase>
	
	<cfcase value="STA">
	   <cfif URL.ID1 neq "all">
	     	<cfset cond = "AND A.ActionCode = '#URL.ID1#'">
	   </cfif>
	</cfcase>

</cfswitch>

   
<cfquery name="SearchResult" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
    SELECT   A.*, 
	         E.PersonNo, 
		     E.IndexNo, 
		     E.FullName, 
		     E.FirstName, 
		     E.LastName, 
		     R.Description
    FROM     EmployeeAction A, 
	         Person E, 
		     Ref_Action R
	WHERE    A.Mission   = '#URL.Mission#'
	 AND     A.MandateNo = '#URL.Mandate#'
	 AND     A.ActionPersonNo = E.PersonNo
		     #preserveSingleQuotes(cond)#
	 AND     A.ActionStatus = '#URL.ID4#'	
	 AND     R.ActionCode = A.ActionCode  
    ORDER BY #orderby#
		
</cfquery>

<cfset counted = SearchResult.recordcount>

<cfif Searchresult.recordcount eq "0">

<table width="96%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr><td class="labellarge" style="padding-top:30px" align="center"><font color="0080C0"><cf_tl id="No records found to be processed"></td></tr>
</table>	

<cfelse>

	<form action="PostEntry.cfm" name="result" id="result" style="height:99%">
	
	<input type="hidden" id="mission" name="mission" value="<cfoutput>#URL.Mission#</cfoutput>">
	
	<table width="96%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0" >
	  <tr>
	    <td height="50" style="padding-top:10px">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td class="labelmedium" style="font-size:22px">
			<cfoutput>
			   <b>#Current.Description#</b> &nbsp;Period: <b>#DateFormat(Current.DateEffective, CLIENT.DateFormatShow)# - #DateFormat(Current.DateExpiration, CLIENT.DateFormatShow)#</b>
	    	</cfoutput>
		   		
		</td>
		
		<td align="right">
		
			<select name="mandate" id="mandate" size="1" class="regularxl" 
			onChange="javascript:reloadForm(page.value,sort.value,layout.value,this.value,detail.value)">
				<cfoutput query="Mandate">
				<option value="#MandateNo#" <cfif URL.Mandate eq "#MandateNo#">selected</cfif>>
		    		#MandateNo# #Description#
				</option>
				</cfoutput>
		    </select>
			 
			<!--- drop down to select only a number of record per page using a tag in tools --->	
			<cf_PageCountN count="#counted#">
			
			<cfif pages gt "1">
			
				<select name="page" id="page" size="1" class="regularxl" 
				onChange="javascript:reloadForm(this.value,sort.value,layout.value,mandate.value,detail.value)">
				    <cfloop index="Item" from="1" to="#pages#" step="1">
				        <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
				    </cfloop>	 
				</SELECT>  	
			
			<cfelse>
			
				<input type="hidden" name="page" value="1" value="page">
			
			</cfif>
	
	    </TD>
		
		</table>
		</td>
		 
	  </tr>
	
	  <tr style="height:20px">
	  
	  <td colspan="2">
	        
		  <table width="100%" border="0">
		    
		  <tr>
		     
		  <td align="left" height="25">
		  
		  <select name="sort" id="sort" size="1" class="regularxl"
			onChange="javascript:reloadForm(page.value,this.value,layout.value,mandate.value,detail.value)">
		     <OPTION value="ActionDate" <cfif URL.Sort eq "ActionDate">selected</cfif>>Sort by Action date
			 <option value="LastName" <cfif URL.Sort eq "LastName">selected</cfif>>Group by Employee
		     <OPTION value="OfficerUserId" <cfif URL.Sort eq "OfficerUserId">selected</cfif>>Group by Officer
		  </select>
		
		   <select name="layout" id="layout" size="1" class="regularxl"
			onChange="javascript:reloadForm(page.value,sort.value,this.value,mandate.value,detail.value)">
		     <OPTION value="Listing" <cfif URL.Lay eq "Listing">selected</cfif>>Listing
			 <option value="Details" <cfif URL.Lay eq "Details">selected</cfif>>Review history
			</select>
		 	
		  </td>
		   
		  </tr>
		   </table>
	  
	  </td>
	  
	  </tr>
	  
	  <tr>
	  <td width="100%" colspan="2" style="height:100%">
	  
	     <cf_divscroll>
	
			<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
			
			<cfparam name="URL.detail" default="#Searchresult.ActionDocumentNo#">
			
			<cfset CLIENT.sort = URL.Sort>
			
			<input type="hidden" id="detail" name="detail" value="<cfoutput>#URL.Detail#</cfoutput>">
			     
			<TR class="line labelmedium">
			    <TD></TD>
			    <TD class="labelit">Employee</TD>
				<TD class="labelit"><cfoutput>#client.IndexNoName#</cfoutput></TD>
				<TD class="labelit">Action</TD>
				<TD class="labelit">Action date</TD>
			    <TD class="labelit">Requested by</TD>
				<TD class="labelit">Reference</TD>
				<TD></TD>
			</TR>
				
				<cfset max = no+first>
				<cfset go = "Yes">
					 
			   <cfoutput query="SearchResult" group="#URL.Sort#" startrow="#first#" maxrows="#No#">
			    
				   <cfif go eq "Yes">
				   
				   <tr>
				  	
					   <cfswitch expression = "#URL.Sort#">
					     <cfcase value = "ActionDate"></cfcase>
						 <cfcase value = "LastName">
					     	<td colspan="10" class="labelmedium" style="font-size:20px;height:40px;padding-left:4px">#LastName#</td>
					     </cfcase>
						 <cfcase value = "OfficerUserId">
					     	<td colspan="10" class="labelmedium" style="font-size:20px;height:40px;padding-left:4px">#OfficerFirstName# #OfficerLastName#</td>
					     </cfcase>				 
					   </cfswitch>
				
				   </tr>
				   
				   </cfif>
			   
				   <cfoutput>
				   
				   <cfif currentrow lt max>
				     
				   <cfif ActionStatus gte "8">  
				   <tr bgcolor="FFD9D9" class="navigation_row labelmedium line">
				   <cfelse>
				   <tr bgcolor="ffffff" class="navigation_row labelmedium line">
				   </cfif>	
				   <TD width="30" align="center">
				  
				   <cfif actiondocumentno neq URL.detail>	 
						<a href="javascript:reloadForm(result.page.value,result.sort.value,result.layout.value,result.mandate.value,'#actiondocumentno#')">
						<img src="#SESSION.root#/Images/icon_expand.gif" alt="" border="0"></A>
				   <cfelse> 
						<a href="javascript:reloadForm(result.page.value,result.sort.value,result.layout.value,result.mandate.value,'')">
						<img src="#SESSION.root#/Images/icon_collapse.gif" alt="" border="0"></A>
				   </cfif>
				   </TD>	
				   		
				   <TD>
				   
				   <cfif actiondocumentno neq URL.detail>	 
						<a href="javascript:reloadForm(result.page.value,result.sort.value,result.layout.value,result.mandate.value,'#actiondocumentno#')">
						#FullName#</A>
				   <cfelse> 
						<a href="javascript:reloadForm(result.page.value,result.sort.value,result.layout.value,result.mandate.value,'')">
						#FullName#</A>
				   </cfif>
				   </TD>
				   
				   <TD><A HREF ="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></TD>
				   <TD>#Description# (#ActionStatus#)</TD>
				   <TD>#DateFormat(ActionDate, CLIENT.DateFormatShow)#</TD>
				   <TD>#OfficerFirstName# #OfficerLastName#</TD>
				   <!---  <TD class="labelit"><A HREF ="javascript:EditAction('#actiondocumentno#')"><font color="0080C0">#actiondocumentno#</A></TD> --->
				   <TD>#actiondocumentno#</TD>	  	
				   <TD><cf_img icon="edit" navigation="Yes" onclick="EditPerson('#PersonNo#')"></td>	
				 
				   </TR>
				         
				   <cfif actiondocumentno eq URL.detail>	
				   
					   <cfif ActionSource eq "Assignment">
					   		
						   <tr><td colspan="9">
					        <cfset url.actionreference = actiondocumentno>
					   		       <cfinclude template="TransactionViewDetail.cfm"> 
							</td>
							</tr>
					   
					   </cfif>
				   
				   </cfif>
				      			
					<cfelse>
					
						<cfset go = "No">
					
					</cfif>
				   
				  </cfoutput>
			     
			</CFOUTPUT>
			
		</TABLE>
			
		</form>
	
		</cf_divscroll>
		
	</td></tr>

</table>	
		
</cfif>



