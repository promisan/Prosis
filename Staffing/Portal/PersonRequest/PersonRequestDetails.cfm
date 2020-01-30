<cfparam name="url.source" default="">

<cfquery name="Search" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT PR.*,E.Description AS EventDescription,PEM.Instruction, TRI.Description TriggerDescription
 FROM PersonRequest PR INNER JOIN Ref_PersonEvent E
 ON E.Code = PR.EventCode INNER JOIN Ref_PersonEventMission PEM
 ON PEM.PersonEvent = E.Code INNER JOIN Ref_PersonEventTrigger ET
 ON ET.EventCode= E.Code INNER JOIN Ref_EventTrigger TRI
 ON TRI.Code = ET.EventTrigger 
 WHERE PEM.EnablePortal = '1'
 AND PR.PersonNo = '#URL.ID#'
 ORDER BY PR.Created	
</cfquery>
    
<style>
    .inactive-img, .inactive-img:hover{
        opacity: 0.4;
    }
    .active-img{
        opacity: 0.5;
    }
    .active-img:hover{
        opacity: 1;
    }
    .Pending{
        color: darkorange;
    }
    .Approved{
        color:darkgreen;
    }
    .Denied{
        color: darkred;
    }
    
    .SplashWindowRight{
    	float:left;
    	width:38%;
    	height:auto;
    	padding:0 1% 0 2.5%;
    }
    
</style>


<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
  <cfoutput>
  <tr>
    <td style="height:70px;font-size:28px;padding-bottom:6px" valign="bottom" class="labellarge">
		<cfif url.source neq "quick">
			<img src="#SESSION.root#/images/Contact-HR.png" height="50" width="50" align="absmiddle" alt="" border="0"  style="float: left; padding-right: 10px;">&nbsp;	
			<h1 style="float:left;color:##333333;font-size:28px;font-weight:200;padding:0;position: relative;top: 5px;"><strong>Ask</strong> my HR Officer</h1>
		<cfelse>
			<img src="#SESSION.root#/Images/Status.png" height="50" width="50" alt="" border="0" style="float: left;">&nbsp;	
            <h1 style="float:left;color:##333333;font-size:28px;font-weight:200;padding:0;position: relative;top: 6px;"><cf_tl id="Requested Document Status"></h1>
		</cfif>		
	</td>
    <td align="right" style="padding-right:5px;padding-bottom:3px" valign="bottom">

		<cf_tl id="Add new request" var="vRequest">			
        <cfif mode eq "edit">
		   
			<a href="javascript:personrequest('#URL.ID#')"><font size="2" face="Verdana" color="0080C0">[#vRequest#]</font></a>	
				
		</cfif>
			
	
   </td>
  </tr>
  </cfoutput>
  
  <tr>  
  <td width="100%" colspan="2">

	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding navigation_table">
		
	<tr><td colspan="9"></td></tr>	
	

	
	<cfif search.recordcount eq "0">
	
		<tr>
		<td colspan="9" height="200" align="center" class="labelit">
			<font size="2" color="gray">There are no requests records to show in this view.</font>
			<cfif url.mode eq "Edit">
			 	<cfoutput>				
				<a href="javascript:personrequest('#URL.ID#')"><font size="2" color="0080C0"><u>[#vRequest#]</font></a>	
		 		</cfoutput>
		 	</cfif>	
		 </td>
		</tr>
	<cfelse>
		<TR  class="labelmedium line">
		    <td height="20" width="1%"></td>
		    <td width="14%" style="text-align: center;"><cf_tl id="Date"></td>		
			<TD width="40%" style="text-align: center;"><cf_tl id="Request"></TD>				
            <cfif url.source neq "quick">
                <TD style="padding-left:4px" width="15%"><cf_tl id="Entity"></TD>
			    <TD style="padding-left:4px" width="20%"><cf_tl id="Reference"></TD>
            </cfif>         
			<TD style="min-width:60px;text-align: center;"><cf_tl id="Status"></TD>
            <TD style="min-width:40px;text-align: center;"><cf_tl id="PDF"></TD>
            <TD style="min-width:60px;text-align: center;"><cf_tl id="Email"></TD>
		</TR>	
	</cfif>	
	
	<cfoutput>
	
		<cfloop query="Search">
		
			<TR class="labelmedium navigation_row line" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f4f4f4'))#" style="height:29px">
			
				<td align="center" style="font-size:16px;padding-left:12px;padding-top:3px;padding-right:12px;border-left: 1px solid ##dddddd;"> 		   
				    <img style="margin: auto;" src="<cfoutput>#session.root#/Images/Edit.png</cfoutput>" class="active-img" width="13" height="13" onclick="requestedit('#URL.ID#','#RequestId#','#url.webapp#')">		  			
				</td>	
				
				<td align="left" style="font-size:16px;text-align: left;padding:2px 8px; border-left: 1px solid ##dddddd;">#DateFormat(RequestDate,CLIENT.DateFormatShow)#</td>	
	
				<td style="font-size:16px;padding:2px 8px; border-left: 1px solid ##dddddd; border-right: 1px solid ##dddddd;">
				    <a href="javascript:requestedit('#URL.ID#','#RequestId#','#url.webapp#')">#TriggerDescription#  : #EventDescription#</a>
				</td>
	            <cfif url.source neq "quick">
				<td style="font-size:16px;padding-left:5px">#Mission#</td>
				<td style="font-size:16px;padding-left:5px">#Reference#</td>
                </cfif>    
	
				<td style="font-size:16px;padding-left:4px;padding-right:5px;border-right: 1px solid ##dddddd;">
					<cfif ActionStatus eq 0>
						<span class="Pending"><cf_tl id="Pending"></span>
					<cfelseif ActionStatus eq 9>	
					    <span class="Denied"><cf_tl id="Denied"></span>
					<cfelse>
						<span class="Approved"><cf_tl id="Approved"></span>
					</cfif>	
				</td>	
                <td style="font-size:16px;text-align: center;border-right: 1px solid ##dddddd;"><img style="padding: 3px 0;" src="<cfoutput>#session.root#/Images/PDF.png</cfoutput>" class="inactive-img" width="18" height="17"></td>
                <td style="font-size:16px;text-align: center;border-right: 1px solid ##dddddd;"><img style="padding: 2px 0;" src="<cfoutput>#session.root#/Images/Email.png</cfoutput>" class="inactive-img" width="18" height="17"></td>
	
			</TR>
		
		</cfloop>
	
	</cfoutput>
  
  	</table>
  </td>
  </tr>
  
 </table>
 