<!--- 
by Jorge Armin Mazariegos
Promisan b.v.
This is a custom tag developed to help developer place a break point 
to troubleshoot a particular piece of code.

The tag receives a LogLine and then adds it up to a Log file 
Two modes of operation :

a) Adding to existing file
b) Writing from scratch an existing file

it can be write or append. 

The name of the output file can now be defined as well in parameter FileName. Added by Nery on 27 oct 2011

--->




<cfparam name="Attributes.Mode"   default="Write">
<cfparam name="Attributes.FileName" default="Log.txt">


<cfif thisTag.ExecutionMode is 'start'>
	<!--- nada --->
	
<cfelse>
		   <cfoutput>
			   <cfsavecontent variable="LogMe">
				#now()#	
				-------------------------------
				#thisTag.GeneratedContent#
				-------------------------------
				</cfsavecontent>
				</cfoutput>
				
	 	    <cffile action="#Attributes.Mode#" 
		      file="#SESSION.rootpath#/#Attributes.FileName#" 
	    	  output="#LogMe#" 
		      addnewline="Yes" 
		      fixnewline="No"> 

</cfif>			  
 
