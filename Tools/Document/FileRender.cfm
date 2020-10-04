<cfparam name="url.mid" default="">

<cfif url.mid neq "">

	<cfinvoke component  = "Service.Process.System.UserController"  
		method            = "RecordSessionTemplate"  
		SessionNo         = "#client.SessionNo#" 
		ActionTemplate    = "#CGI.SCRIPT_NAME#"
		Hash              = "#URL.mid#"
		ActionQueryString = "#CGI.QUERY_STRING#">	

	<!--- validate access --->
		
	<cfinvoke component   = "Service.Process.System.UserController"  
	   	method            = "ValidateFunctionAccess"  
		SessionNo         = "#client.SessionNo#" 
		ActionTemplate    = "#CGI.SCRIPT_NAME#"
		ActionQueryString = "#CGI.QUERY_STRING#">		

</cfif>	

<cfparam name="Attributes.SourceDirectory" default="#client.sd#">
<cfparam name="Attributes.SourceFileName"  default="#client.sf#">
		
<cfset Path = Attributes.SourceDirectory & Attributes.SourceFileName />
		 		
<cfset vDestination = "inline">		 		
		 		  
<cfswitch expression="#LCase(ListLast(Attributes.SourceFileName, "."))#">

    <cfcase value="xml">
        <cfset vContentType = "application/xml" />
        <cfset vDestination = "attachment">
    </cfcase>

    <cfcase value="avi">
        <cfset vContentType = "video/x-msvideo" />
    </cfcase>
	
    <cfcase value="gif">
        <cfset vContentType = "image/gif" />
    </cfcase>
	
    <cfcase value="jpg,jpeg">        
		<cfset vContentType = "image/jpg" />				
    </cfcase>
	
    <cfcase value="mp3">
        <cfset vContentType = "audio/mpeg" />
    </cfcase>
	
    <cfcase value="mov">
        <cfset vContentType = "video/quicktime" />
    </cfcase>
	
    <cfcase value="mpe,mpg,mpeg">
        <cfset vContentType = "video/mpeg" />
    </cfcase>
	
    <cfcase value="pdf">
        <cfset vContentType = "application/pdf" />
    </cfcase>
	
    <cfcase value="png">
        <cfset vContentType = "image/png" />
    </cfcase>
	
    <cfcase value="ppt">
        <cfset vContentType = "application/vnd.ms-powerpoint" />
    </cfcase>
	
    <cfcase value="wav">
        <cfset vContentType = "audio/x-wav" />
    </cfcase>
	
    <cfcase value="xls">
        <cfset vContentType = "application/vnd.ms-excel" />
    </cfcase>

    <cfcase value="xlsx">
        <cfset vContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" />
    </cfcase>
	
    <cfcase value="doc,docx">
        <cfset vContentType = "application/msword" />
    </cfcase>
	
    <cfcase value="zip">
        <cfset vContentType = "application/zip" />
    </cfcase>
	
    <cfdefaultcase>
        <cfset vContentType = "application/unknown" />
    </cfdefaultcase>
	
</cfswitch>

<!--- change so all files will be rendered as an attachment --->
<cfset vDestination = "attachment">

<cftry>
		
    <cfheader name="Content-disposition"  value="#vDestination#; filename=#Replace(Replace(Attributes.SourceFileName, " ",  "_", "all"),",","&##44;","ALL")#" />
	<cfheader name="Content-length" value="#getFileInfo(Path).size#" />
			
	<cfcontent type="#vContentType#" file="#Path#"/>
		
<cfcatch>

	<cfset m = Message()>
	
</cfcatch>	
</cftry>									

<cffunction name="Message">

   <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	 <tr><td align="center" height="40" class="labelmedium">		   
		   <cf_tl id="This document link has expired. Go to the original document and click on it again"  class="Message">		 
		</td>
	 </tr>
   </table>	
   <cfabort>	
		   
</cffunction>