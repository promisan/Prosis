
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfoutput>
<!--- read the dbfiles --->

<cfquery name="upload" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
FROM     stProgramMeasure
WHERE    FileNo IN (#preservesinglequotes(URL.fileNo)#) 
ORDER BY fileName DESC
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
   <td colspan="4">&nbsp;&nbsp;<b>Upload monitoring</b></td>
</tr>
<tr>
   <td colspan="4" height="1" bgcolor="e4e4e4"></td>
</tr>   
<tr>
   <td colspan="4" height="4"></td>
</tr>	
</table>  

<cfset cnt = 0>
<table><tr><td height="20">&nbsp;&nbsp;&nbsp;Initiating.... [ts: <b></b>#dateformat(now(), CLIENT.DateFormatShow)# : #timeformat(now(), "HH:MM:SS")#</b>]</td></tr></table>
<cfflush>

<cfloop query="upload">

	<cfset dbfile  = upload.fileName>
	<cfset ds      = upload.datasource>
	<cfset mission = upload.Mission>
	<cfset period  = upload.Period>
	<cfset source  = upload.Source>
		
	<!--- define program --->
		
	<table><tr><td width="50" align="center"><img src="#SESSION.root#/Images/dataset_connect.gif" alt="" border="0"></td>
	<td height="20">
	&nbsp; Dataset: &nbsp;&nbsp;<b>#dbfile#</b></td></tr></table>
	<cfflush>
		
	<cftry>
	<cfquery name="Location" 
	datasource="#ds#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE   #dbfile# 
	SET      LocationCode = ''
	WHERE    LocationCode is NULL
	</cfquery>
		
	<cfcatch>
	
	<cfoutput>
	</cfoutput>
	   <table><tr><td width="50"></td><td height="20">&nbsp;&nbsp;&nbsp;&nbsp; <font color="FF0000">Error, incorrect file name (#dbfile#)</b></td></tr></table>
	   <cfflush>
	   
	   <cfabort>
	</cfcatch>
	
	</cftry>
	
	 <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#_upload">	
	 <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#tmpMeasure">
	
	
	<table><tr>
	<td width="50" align="center">&nbsp;&nbsp;<img src="#SESSION.root#/Images/dataset_read.gif" alt="" border="0"></td>
	<td height="20">&nbsp;&nbsp;&nbsp;&nbsp; Retrieving data.....  </b></td></tr></table>
	<cfflush>
				
	<cfquery name="DefineProgram" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     Pe.ProgramCode, 
				   Pe.Period, 
				   MS.ReferenceCode, 
		           MS.OrgUnitCode, 
				   MS.IndicatorCode, 
				   MS.LocationCode
		INTO       userQuery.dbo.#SESSION.acc#tmpMeasure
		FROM       #dbfile# MS INNER JOIN
		           Organization.dbo.Organization Org 
				   ON MS.OrgUnitCode = Org.OrgUnitCode INNER JOIN
		           ProgramPeriod Pe ON Org.OrgUnit = Pe.OrgUnit 
				                     AND MS.ReferenceCode = Pe.Reference
		WHERE      Org.Mission = '#Mission#'
		AND        Pe.Period = '#Period#'		
	</cfquery>
	
	<table><tr><td width="50"></td><td height="20">&nbsp;&nbsp;&nbsp;&nbsp; Preparing data.....</td></tr></table>
	<cfflush>
	
	<cfquery name="UpdateSourceTarget" 
	datasource="#ds#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE    #dbfile#
	SET       _TargetId = NULL,
	          _AuditId = NULL
	</cfquery>
	
	<cfquery name="UpdateSourceTarget" 
	datasource="#ds#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE    #dbfile#
	SET       Measurement = 0, MeasurementCount=0, MeasurementBase=1
    WHERE     Measurement is NULL
	</cfquery>
	
	<!--- make a local server copy into maybe not needed -
	
	<cfquery name="LocalCopy" 
	datasource  = "appsQuery" 
	username    = "#SESSION.login#" 
	password    = "#SESSION.dbpw#">
	   SELECT *
   	   INTO   dbo.#SESSION.acc#_upload
	   FROM   #dbfile# 
	</cfquery>
	
	--->
		
	<cfquery name="UpdateFileTarget" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE    #dbfile#
	SET       _TargetId = Ind.Targetid
	FROM      userQuery.dbo.#SESSION.acc#tmpMeasure T INNER JOIN
	          ProgramIndicator Ind ON T .ProgramCode = Ind.ProgramCode 
			                      AND T.Period = Ind.Period 
								  AND T.IndicatorCode = Ind.IndicatorCode 
								  <cfif #upload.LocationEnabled# eq "1">
								  AND T.LocationCode = Ind.LocationCode 
								  </cfif>
			  INNER JOIN
	          #dbfile# S ON T.ReferenceCode = S.ReferenceCode 
	                        AND T.OrgUnitCode = S.OrgUnitCode 
							AND T.IndicatorCode = S.IndicatorCode 
							<cfif #upload.LocationEnabled# eq "1">
							AND T.LocationCode = S.LocationCode
							</cfif> 
								
	</cfquery>
	
	<table><tr><td width="50"></td><td height="20">&nbsp;&nbsp;&nbsp;&nbsp; Preparing upload.....</td></tr></table>
	<cfflush>	
			
	<cfquery name="UpdateFileAudit" 
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE    #dbfile#
	SET       _AuditId = A.AuditId
	FROM      #dbfile# MS INNER JOIN
	                Ref_Audit A ON MS.AuditDate = A.AuditDate
	AND A.Period = '#Period#'					  
	</cfquery>
	
	<!--- clean prior entries --->
	
	<cfif upload.overwrite eq "1">
	
		<cfquery name="UpdateSourceAudit" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM ProgramIndicatorAudit
		WHERE TargetId IN
	               (SELECT DISTINCT _TargetId
	                FROM   #dbfile#)  
	   	  AND Source = '#Source#'
		  AND AuditId IN (SELECT DISTINCT _AuditId 
		                   FROM #dbfile#) 
		</cfquery>		
		
		<cfquery name="UpdateSourceAudit" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM ProgramIndicatorAudit
		WHERE (TargetId IN
	               (SELECT DISTINCT _TargetId
	                FROM   #dbfile#)) 
	   	 AND (AuditStatus <= '0' or AuditStatus is NULL)
		 AND Source = 'Manual'
		 AND AuditId IN (SELECT DISTINCT _AuditId 
		                   FROM #dbfile#)
		</cfquery>				 
		
	</cfif>
	
	<!--- source --->
			 
	<cfloop index="k" list="#source#,Manual">
	
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#ProgramUpload">	
	
	<table><tr><td width="50" align="center">&nbsp;&nbsp;<img src="#SESSION.root#/Images/dataset_write.gif" alt="" border="0"></td>
	<td height="20">&nbsp;&nbsp;&nbsp;&nbsp; Uploading into database for source :<b>#k#</b></td></tr></table>
	<cfflush>
	
	<cfquery name="Tmp" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT MeasurementId, TargetId, AuditId
		INTO   userQuery.dbo.#SESSION.acc#ProgramUpload
		FROM   ProgramIndicatorAudit
		WHERE Source = '#k#'
		<cfif #k# eq "Manual">
		AND   AuditStatus <= '1'
	</cfif>
	</cfquery>
	
	<cfquery name="Insert" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO ProgramIndicatorAudit
		(Targetid, 
		 AuditId, 
		 Source, 
		 AuditTargetValue, 
		 AuditTargetCount, 
		 AuditTargetBase, 
		 AuditStatus, 
		 OfficerUserId)
		SELECT     DISTINCT 
		           SRC._TargetId, 
				   SRC._AuditId, 
				   '#k#', 
		           SRC.Measurement, 
				   SRC.MeasurementCount, 
				   SRC.MeasurementBase,
				   '1',
				   'Upload'
	    FROM       #dbfile# SRC LEFT OUTER JOIN
	               userQuery.dbo.#SESSION.acc#ProgramUpload PA ON SRC._TargetId = PA.TargetId AND SRC._AuditId = PA.AuditId
		WHERE     (SRC._TargetId IS NOT NULL) AND (SRC._AuditId IS NOT NULL)			   
	    GROUP BY   PA.MeasurementId,
		           SRC._TargetId, 
		           SRC._AuditId, 
		           SRC.Measurement, 
	               SRC.MeasurementCount, 
				   SRC.MeasurementBase 
	    HAVING     PA.MeasurementId IS NULL
	</cfquery>
		
	<!--- copy the local copy back to the original --->
		
	</cfloop>
	
	<table><tr><td width="50"></td><td height="20">&nbsp;&nbsp;Finishing.....</td></tr></table>
	<cfflush>
				
	
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#tmpMeasure">
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#ProgramUpload">
		
	<cfquery name="Check" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   ProgramIndicatorAudit
	WHERE  OfficerUserid = 'Upload'
	AND    Created > getDate()-1
	</cfquery>
		
	<cfset cnt = #cnt# + #check.recordcount#>
	
	<cfif check.recordcount eq "0">
	<cfset c = "red">
	<cfelse>
	<cfset c = "black">
	</cfif>
	<table><tr><td width="50" align="center">
	<cfif #check.recordcount# eq "0">
		<img src="#SESSION.root#/Images/attention2.gif" alt="" border="0">
	</cfif>
	</td><td height="20">&nbsp; <font color="#c#">Upload completed : #check.recordcount# measurements uploaded</td></tr></table>
	<cfflush>
	
				
</cfloop>

<table><tr><td width="50"></td><td><br>&nbsp; >>> <b>Batch completed : #cnt# measurements uploaded</b> <<<</td></tr></table>
	<cfflush>
	
<script language="JavaScript">

{
alert("#cnt# measurements have been updated. Completed.")
parent.ColdFusion.Window.hide('process')
}

</script>
</cfoutput>

</table>
