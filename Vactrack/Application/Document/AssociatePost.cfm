
<cf_screentop height="100%" layout="webapp" close="parent.ColdFusion.Window.destroy('myassociate',true)" banner="gray" line="no" label="Associate - Position to recruitment request" band="No" scroll="Yes">

<cfoutput>

<script>

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }	 
	 	 		 	
	 if (fld != false){		
	 itm.className = "highLight2";	 
	 }else{		
     itm.className = "regular";		
	 }
  }
  
function EditPost(posno) {
     w = #CLIENT.width# - 60;
     h = #CLIENT.height# - 130;
     window.open("#SESSION.root#/Staffing/Application/Position/Position/PositionView.cfm?ID=" + posno, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}	 

</script>

</cfoutput>

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Assign">

<cfquery name="CheckData" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    PA.DateEffective AS AssignmentEffective, 
          PA.DateExpiration AS AssignmentExpiration, 
		  PA.PositionNo, 
		  E.IndexNo, 
		  E.LastName, 
		  E.FirstName, 
          PA.PersonNo		
INTO      userQuery.dbo.#SESSION.acc#Assign		  
FROM      Position Post INNER JOIN
          PersonAssignment PA ON Post.PositionNo = PA.PositionNo INNER JOIN
          Person E ON PA.PersonNo = E.PersonNo
WHERE     Post.Mission = '#URL.ID1#'
AND       PA.DateExpiration >= getDate()
AND       PA.DateEffective <= getDate()
AND       AssignmentStatus IN ('0','1') 
</cfquery>

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    *
FROM      Ref_Mandate
WHERE     Mission = '#URL.ID1#'
AND       MandateDefault = 1
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    TOP 1 *
	FROM      Ref_Mandate
	WHERE     Mission = '#URL.ID1#'
	ORDER BY  DateEffective DESC
	</cfquery>
	
	<cfset man = "M.MandateNo = '#Check.MandateNo#'">
	
<cfelse>	

    <cfset man = "M.MandateDefault = 1">

</cfif>

<!--- retrieve positions from current/default mandate --->

<cfquery name="Post" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT P.*, A.*,
	          (SELECT count(*) 
		          FROM   Vacancy.dbo.DocumentPost S
		 		  WHERE  DocumentNo = '#URL.ID#'
				  AND    PositionNo = P.PositionNo) as CurrentAssigned	
			 
	FROM      Employee.dbo.Position P INNER JOIN
              Organization.dbo.Ref_Mandate M ON P.Mission = M.Mission LEFT OUTER JOIN
              userQuery.dbo.#SESSION.acc#Assign A ON P.PositionNo = A.PositionNo	
	WHERE     P.Mission = '#URL.ID1#' 
	AND       #preserveSingleQuotes(man)#
	AND       P.DateExpiration > getDate()      
	AND       P.PostGrade = '#URL.ID2#' 
	ORDER BY  CurrentAssigned DESC, P.SourcePostNumber 
</cfquery>

<cfif Post.recordcount eq "0">
	
	<!--- extract the mandate from the existing positionnumber --->
	
	<cfquery name="Check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    TOP 1 *
		FROM      Ref_Mandate
		WHERE     Mission = '#URL.ID1#'
		AND       MandateNo IN (SELECT MandateNo FROM Employee.dbo.Position WHERE PositionNo IN (SELECT Positionno FROM Vacancy.dbo.DocumentPost WHERE DocumentNo = '#URL.ID#'))	
	</cfquery>
		
	<cfif Check.recordcount gte "1">
	
		<cfset man = "P.MandateNo = '#Check.MandateNo#'">
				
		<cfquery name="Post" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT P.*, A.*,
					 (SELECT count(*) 
				          FROM   Vacancy.dbo.DocumentPost S
				 		  WHERE  DocumentNo = '#URL.ID#'
						  AND    PositionNo = P.PositionNo) as CurrentAssigned	
			FROM      Employee.dbo.Position P  LEFT OUTER JOIN
		              userQuery.dbo.#SESSION.acc#Assign A ON P.PositionNo = A.PositionNo		  				  
			WHERE     P.Mission = '#URL.ID1#' 
			AND       #preserveSingleQuotes(man)#			
			AND       P.PostGrade = '#URL.ID2#' 
			ORDER BY  CurrentAssigned DESC, P.SourcePostNumber  
		</cfquery>
	
	</cfif>

</cfif>

<cf_dialogStaffing>

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Assign">

<form action="AssociatePostSubmit.cfm" method="post" target="result">
	  
<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">

  <tr class="hide"><td><iframe name="result" id="result"></iframe></td></tr>

  <tr><td height="4"></td></tr>

  <tr><td height="23" class="labelit">&nbsp;Organization: <b><cfoutput>&nbsp;#URL.ID1#</b> &nbsp;Grade level: <b>#URL.ID2#</cfoutput></b></td></tr>

  <cfoutput>
     <input type="hidden" name="DocumentNo" value="#URL.ID#">
  </cfoutput>
  
  <tr><td>

  <table border="0" cellpadding="0" cellspacing="0" width="100%">

	  <TR class="labelmedium line">
	    <td></td>
		<TD>Post number</TD>
	    <TD class="labelit">Function</TD>
	    <TD class="labelit">Grade</TD>
		<TD class="labelit">Expiration</TD>
		<TD class="labelit">IndexNo</TD>
		<TD class="labelit">Name</TD>
		<TD class="labelit">End date</TD>
	  </TR>
	
	  <cfoutput query="Post"> 
	 
	 	
	  <cfif CurrentAssigned eq "0">
	     <tr class="regular labelmedium line">
	  <cfelse>
	     <tr class="highLight2 labelmedium line">
	  </cfif>   
	  
	  
	  <TD>&nbsp;  
	  <cfif CurrentAssigned eq "0">
	    <input type="checkbox" name="Selected" value="#PositionNo#" onClick="hl(this,this.checked)">
	  <cfelse>
	    <input type="checkbox" name="Selected" value="#PositionNo#" checked onClick="hl(this,this.checked)">
	  </cfif>
	  </TD>
	    <TD>#SourcePostNumber#</TD>
		<TD><a href="javascript:EditPost('#PositionNo#')"><font color="0080C0">#FunctionDescription#</a></TD>
		<TD><a href="javascript:EditPost('#PositionNo#')">#PostGrade#</a></TD>
	    <TD>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</TD>
		<TD><a href="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></TD>
		<TD>#FirstName# #LastName#</TD>
		<TD>#Dateformat(AssignmentExpiration, CLIENT.DateFormatShow)#</TD>
	</TR>

	</CFOUTPUT>

	<tr><td height="42" colspan="8" align="center">
	
	<input class="button10g" style="width:140;height:29" type="submit" name="Update" value="Associate">

</td></tr>

</TABLE>
</td>
</tr>

</table>

</form>

<cf_screenbottom layout="webapp">
	