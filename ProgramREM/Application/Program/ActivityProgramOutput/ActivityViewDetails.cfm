<cfoutput query="SearchResult" group="Reference">

<tr>
     <td colspan="6" bgcolor="f4f4f4">&nbsp;<b>#Reference#</b></td>
</tr>

<cfoutput>

	<CFIF ProgramAccess EQ "ALL"> 
	 
		<tr bgcolor="white" #stylescroll# 
		     onContextMenu="cmexpand('mymenu','#client.dropdownno#','')" 
			 onclick="cmclear('mymenu')">
			 
		<td align="center" id="myname#client.dropdownno#" class="hide">
			
			<cf_dropDownMenu
			     name="menu"
		   	     headerName="Activity"
			     menuRows="4"
				 
				 menuName1="Edit activity"
			     menuAction1="javascript:AddActivity('#URL.ProgramCode#','#URL.Period#','#SearchResult.ActivityId#')"
			     menuIcon1="#SESSION.root#/Images/edit.jpg"
			     menuStatus1="Edit activity"
				 
			     menuName2="Remove activity"
			     menuAction2="javascript:DeleteActivity('#URL.ProgramCode#','#URL.Period#','#ActivityID#','#ProgramAccess#')"
			     menuIcon2="#SESSION.root#/Images/cancelN.jpg"
			     menuStatus2="Remove activity"
			  
			     menuName3="Add output"
			     menuAction3="javascript:AddOutputs('#SearchResult.ProgramCode#','#SearchResult.ActivityPeriod#','#SearchResult.ActivityId#','')"
			     menuIcon3="#SESSION.root#/Images/zoomin.jpg"
			     menuStatus3="Add deliverable"
			  
			     menuName4="Attachment"
			     menuAction4="javascript:addfile('#Parameter.DocumentLibrary#','#ProgramCode#','#SearchResult.ActivityId#')"
			     menuIcon4="#SESSION.root#/Images/copy.jpg"
			     menuStatus4="Attach a document">	
					 
		</td>			   
	
	<cfelse>
	
		<tr bgcolor="white" #stylescroll#>
		<td align="center"></td>
	
	</cfif>
	
<TD class="labelit" Colspan="5">
	<b>#SearchResult.ActivityDescription#</b>
</TD>
	
</TR>
<tr>
	 <td colspan="1"></td>
	 <td colspan="5">
	 
	 <CFIF ProgramAccess EQ "ALL"> 
	 
		 <cf_filelibraryN
			DocumentPath="#Parameter.DocumentLibrary#"
			SubDirectory="#SearchResult.ProgramCode#" 
			Filter="#SearchResult.ActivityId#"
			Insert="yes"
			Remove="yes"
			Highlight="no"
			Listing="yes">
		
	 <cfelse>
	 
		  <cf_filelibraryN
			DocumentPath="#Parameter.DocumentLibrary#"
			SubDirectory="#SearchResult.ProgramCode#" 
			Filter="#SearchResult.ActivityId#"
			Insert="no"
			Remove="no"
			Highlight="no"
			Listing="yes">
	 
	 </cfif>	
		
	</td>
</tr>

<tr class="line"><td colspan="6"></td></tr>

<cfset Cond = "">	

<cfif #URL.Sorting# eq "period">
    <cfset Cond = " AND O.ActivityPeriodSub = '#Sub#'">
</cfif>

<cfquery name="OutputPeriods" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   DISTINCT O.ActivityPeriodSub, S.DescriptionShort
FROM     ProgramActivityOutput O, Ref_SubPeriod S
WHERE    O.ActivityId = '#SearchResult.ActivityId#' 
 AND     O.ProgramCode = '#SearchResult.ProgramCode#'
 AND     S.SubPeriod = O.ActivityPeriodSub
         #PreserveSingleQuotes(cond)#
ORDER BY S.DescriptionShort
</cfquery>

<cfset OutActivityID     = SearchResult.ActivityID>
<cfset OutActivityPeriod = SearchResult.ActivityPeriod>
<cfset OutProgramCode    = SearchResult.ProgramCode>

<cfloop query="OutputPeriods">

<cfif OutActivityID eq URL.ExpandOutput AND OutputPeriods.ActivityPeriodSub eq URL.ExpandSubPeriod>

<!--- show this activity's output expanded --->

	<cfinclude template="../ActivityProgramOutput/OutputProgressEntry.cfm">

<cfelse>

<cfquery name="Output" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    O.*, S.DescriptionShort
	FROM      #CLIENT.LanPrefix#ProgramActivityOutput O, Ref_SubPeriod S
	WHERE     O.ActivityId = '#OutActivityID#' 
	 AND      O.ProgramCode = '#OutProgramCode#' 
	 AND      O.ActivityPeriodSub = '#OutputPeriods.ActivityPeriodSub#'
	 AND      (O.RecordStatus <> 9 OR O.RecordStatus IS NULL)
	 AND      S.SubPeriod = O.ActivityPeriodSub
	 Order by S.DescriptionShort
</cfquery>

<tr>
<td height="1" colspan="6">
<table width="100%" border="0" cellspacing="0" cellpadding="0">

<cfset period = "">

<cfloop query="Output">

	<tr class="labelit">
	
    <cfif Period neq ActivityPeriodSub>

     	 <cfset period = "#ActivityPeriodSub#">
		 
		 <TD width="5%" valign="top" align="right" valign="top" class="regular">&nbsp;</TD>
		 <td width="5%" align="left" valign="top" style="padding-left:6px">	
		<cfif ProgramAccess eq "EDIT" or ProgramAccess eq "ALL">  <!--- access invoked by ComponentViewHeader --->
			<!--- diabled on Kristina's request
				<a href="javascript:ReloadActivities('#SearchResult.ProgramCode#','#SearchResult.ActivityPeriod#','#ActivityId#','#ActivityPeriodSub#')">
				<img src="#SESSION.root#/Images/zoomin.jpg" alt="" width="10" height="9" border="0"></A>
	        --->			
		</cfif>
		#DescriptionShort#
		</td>
		 
	<cfelse>	
		<td width="5%" valign="top" align="right">&nbsp;</td>
        <td width="5%"></td>
	</cfif>	 
	
	<td width="3%" valign="top">
		
	<CFIF ProgramAccess EQ "ALL"> 
	
		<table><tr>
		<td>
		<cf_img icon="edit" onclick="EditOutput('#URL.ProgramCode#','#URL.Period#','#OutActivityID#','#OutputID#')">
		</td>
		<td style="padding-left:3px;padding-top:1px">
		<cf_img icon="delete" onclick="DeleteOutput('#URL.ProgramCode#','#URL.Period#','#OutputID#','#ProgramAccess#')">		
		</td>
		
		</tr></table>
		
		<!---

	 <img src="#SESSION.root#/Images/view.jpg" alt="" name="img1_#CLIENT.dropdownno#" 
		  onMouseOver="document.img1_#CLIENT.dropdownno#.src='#SESSION.root#/Images/button.jpg'" 
		  onMouseOut="document.img1_#CLIENT.dropdownno#.src='#SESSION.root#/Images/view.jpg'"
		  style="cursor: pointer;" alt="" width="11" height="13" border="0" align="top" 
		  onClick="expand('menu','#CLIENT.dropdownno#')">
		  
      <cf_dropDownMenu
	     name="menu"
   	     headerName="Output"
	     menuRows="2"
		 
		 menuName1="Edit output"
	     menuAction1="javascript:EditOutput('#URL.ProgramCode#','#URL.Period#','#OutActivityID#','#OutputID#')"
	     menuIcon1="#SESSION.root#/Images/edit.jpg"
	     menuStatus1="Edit output"
		 
	     menuName2="Remove output"
	     menuAction2="javascript:DeleteOutput('#URL.ProgramCode#','#URL.Period#','#OutputID#','#ProgramAccess#')"
	     menuIcon2="#SESSION.root#/Images/cancelN.jpg"
	     menuStatus2="Remove output">		
		 
		 ---> 
	  	  
    </cfif> 
			
	</td>
    	
    <td width="30%" valign="top">#Output.ActivityOutput#</td>
	<td width="10%" valign="top" align="left">#DateFormat(ActivityOutputDate, CLIENT.DateFormatShow)#&nbsp;</td>	
	
	<cfquery name="Progress" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ProgramActivityProgress A, Ref_Status S 
	    WHERE  A.OutputId = '#Output.OutputId#' 
	    AND    A.ProgramCode = '#Output.ProgramCode#' 
	    AND    A.ProgressStatus = S.Status 
		AND	   (A.RecordStatus <> 9 OR A.RecordStatus is NULL)
	    AND    S.ClassStatus = 'Progress'
		ORDER BY Created
    </cfquery>
	
	<cfif Progress.recordcount gt "0">
	
    	<td width="56%" valign="top" bgcolor="ffffcf">
	
	<cfelse>
	
    	<td width="56%" valign="top">
	
	</cfif>
   				
		<!---  <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="FCFED3"> --->
		<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <cfloop query="Progress">
		  
		  <cfif ProgressStatus neq 0>	
		   <tr>
		    
			<td width="40%" align="left" valign="top" class="regular">
			     <cfif ProgressStatus eq 0>
				     <img src="#SESSION.root#/Images/arrow.gif" alt="" width="10" height="10" border="0" align="bottom"></A>&nbsp;&nbsp;
				 <cfelseif ProgressStatus eq 1>
					 <img src="#SESSION.root#/Images/check.gif" alt="" width="10" height="10" border="0" align="bottom"></A>&nbsp;&nbsp;
				 <cfelseif ProgressStatus eq 2>
					 <img src="#SESSION.root#/Images/pending.gif" alt="" width="10" height="10" border="0" align="bottom"></A>&nbsp;&nbsp;
				 <cfelse>
					 <img src="#SESSION.root#/Images/pending.gif" alt="" width="10" height="10" border="0" align="bottom"></A>&nbsp;&nbsp;
				 </cfif>&nbsp;#Description#	(#DateFormat(ProgressStatusDate, CLIENT.DateFormatShow)#)			 
			    </td>
			<td width="40%" align="left" valign="top" class="regular">#OfficerFirstName# #OfficerLastName# (#DateFormat(Created, CLIENT.DateFormatShow)#)</td>
			<TD width="5%" valign="top" style="padding-right:5px">
				<cfif ProgramAccess eq "ALL">
					<a  href="javascript:DeleteProgress('#URL.ProgramCode#','#URL.Period#','#ProgressID#')">
					<img src="#SESSION.root#/Images/cancelN.jpg" alt="" border="0" align="middle">
					</a>
				</cfif>
			</td>
			</tr>
			<tr>
			<td colspan="4" valign="top" style="padding-right:5px"><A HREF ="javascript:EditProgress('#Progress.ProgramCode#','#Progress.ProgressId#')">#Progress.ProgressMemo#&nbsp;</a></td>
			</tr>
		
			</cfif>
		   </cfloop>
		     
		  </table>	
		  
	</td></tr>	  
   
</cfloop> 

</td></tr></table>

</td>
</tr>

</cfif>

</cfloop>

</cfoutput>

</cfoutput>