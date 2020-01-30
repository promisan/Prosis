<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_dialoglookup>
<cf_dialogStaffing>

<cfparam name="URL.RosterAction" default="0">

<cfinvoke component="Service.Access"  
	   method="useradmin" 
	   returnvariable="access">	

<cfoutput>

<cf_ajaxRequest>

<script language="JavaScript">

function update(id,acc,lvl,cond) {
			
	url = "ControlListingDetailUpdate.cfm?functionid="+id+"&account="+acc+"&accesslevel="+lvl+"&accesscondition="+cond
	            
	AjaxRequest.get({
        'url':url,
        'onSuccess':function(req){		
	    },					
        'onError':function(req) { 			      
	       document.getElementById("select").innerHTML = req.responseText;}	
         }
	 );			 
	 }			 

function process(acc) {
	    window.open("UserAccess.cfm?ID=#URL.ID#&ID1=#URL.Status#&acc=" + acc, "_blank", "width=800, height=600, status=yes, toolbar=no, scrollbars=no, resizable=no");
}

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld,s){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){		
		 itm.className = "highLight"+s;
	 }else{		
	     itm.className = "regular";		
	 }
  }
  
</script>  

  <form action="ControlBatch.cfm?RosterAction=#URL.RosterAction#&ID=#URL.ID#&ID1=#URL.Status#&FunctionId=#URL.FunctionId#&Row=#URL.Row#&Mode=#URL.Mode#" method="post" name="result">
  
		<cfquery name="Officer" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  A.*, N.*
		FROM    RosterAccessAuthorization A, 
		        System.dbo.UserNames N
		WHERE   A.UserAccount = N.Account
		AND     A.FunctionId = '#URL.FunctionId#'
		AND     A.AccessLevel = '#URL.Status#' 
		<cfif #URL.Mode# eq "Roster">
		AND     A.Source = 'Manual'
		</cfif>
		ORDER BY LastName
		</cfquery>
				
		<table width="98%" bordercolor="e4e4e4" cellspacing="0" cellpadding="0" align="right" bgcolor="e4e4e4">
		
		<tr><td>
		
		<table width="100%" cellspacing="0" cellpadding="0" align="right" bgcolor="ffffff">
		
		<cfset cnt = 0>
		
		<cfloop query="Officer">
		
		    <cfset cnt = cnt + 1>
		
			<tr>
			
			<cfif Access eq "EDIT" or Access eq "ALL">
			 
				<td width="5%" align="center">
				
					<img src="#SESSION.root#/Images/access1.gif" 
					onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/Button.jpg'" 
					onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/access1.gif'"
					alt="User profile" name="img0_#currentrow#" 
					id="img0_#currentrow#" border="0" align="middle" 
					onClick="javascript:process('#Account#')">
					
				</td>
					
				<td width="10%">&nbsp;&nbsp;<a href="javascript:ShowUser('#URLEncodedFormat(Account)#')">#Account#</a></td>
			
			<cfelse>
			
				<td colspan="2" width="10%">&nbsp;&nbsp;#Account#</a></td>
			
			</cfif>
			
			<td width="20%"><a href="javascript:ShowUser('#URLEncodedFormat(Account)#')">#LastName#, #FirstName# </a></td>
			<td width="10%">#AccountGroup#</td>
			<td width="80">
			
				<cfif URL.RosterAction eq "1">
				<table cellspacing="0" cellpadding="0"><tr><td>
				
				<cfquery name="Check" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * FROM RosterAccessAuthorization
				WHERE     FunctionId = '#FunctionId#'
				AND       UserAccount = '#UserAccount#' 
				AND       AccessLevel = '9'
				</cfquery>	
				<input type="radio" name="AccessCondition#CurrentRow#" value="Full" <cfif #Check.recordcount# eq "1">checked</cfif> onclick="update('#FunctionId#','#UserAccount#','#AccessLevel#','Full')">
				</td><td>Allow&nbsp;Deny&nbsp;</td><td>
				<input type="radio" name="AccessCondition#CurrentRow#" value="Limited" <cfif #Check.recordcount# eq "0">checked</cfif> onclick="update('#FunctionId#','#UserAccount#','#AccessLevel#','Limited')">
				</td><td>Limited</td></tr></table>
				</cfif>
			</td>
			<td width="20%">#OfficerFirstName# #OfficerLastName#</td>
			<td width="10%">#DateFormat(Created, CLIENT.DateFormatShow)#</td>
			<td width="5%" align="left">
				<input type="checkbox" name="RecordId" value="'#RecordId#'" onClick="hl(this,this.checked,'2')"></td>
			</tr>
					
		</cfloop>
				
		<tr>

        <td colspan="8">
		
        <table width="100%" cellspacing="0" cellpadding="0">
        <td height="25" colspan="1" align="left" valign="middle">
        &nbsp;
		<cfif officer.recordcount neq "0">
        <input type="submit" name="Refresh" value="Refresh" style="height:19px" class="button10g" onClick="location.reload()">&nbsp;
		</cfif>
        </td>

        <td height="25" colspan="3" align="right" valign="middle">
		
		<cfif URL.Mode eq "Roster">
			<input type="button" name="Officer" value="Add user" style="height:19px" class="button10g" onClick="userlocate('rosterbucket','#URL.ID#','#URL.Status#')">&nbsp;
		<cfelse>
			<input type="button" name="Officer" value="Add user" style="height:19px" class="button10g" onClick="userlocate('rosteraccess','#URL.ID#','#URL.Status#')">&nbsp;
		</cfif>
		
		<cfif officer.recordcount neq "0">
		
		<input type="submit" name="Purge" value="Remove" style="height:19px" class="button10g">&nbsp;
		
		</cfif>
		
        </td>
        </table>
        </td>
		
        </tr>

     </table>
	 
	 </tr>
	 
	 </table>
	 
	 <script language="JavaScript">

		{
		frm  = parent.document.getElementById("i#URL.row#");
		he = 30 + (#cnt# * 21);
		frm.height = he
		}

     </script>
	      	
		
  </form>		
  			
</cfoutput>	



