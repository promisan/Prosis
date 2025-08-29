<!--
    Copyright © 2025 Promisan B.V.

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
<cfif Attributes.Theme eq "default">
	
	<style>
		   #Process,	
	       #Back,
	       #Reset,
		   #Current,
	       #Next,
	       #NextLast{
	          margin-right: 10px;
	          border-radius:5px!important;
	       }
	       
		   #Process div,		   
	       #Back div,
	       #Reset div,
		   #Current div,
	       #Next div,
	       #NextLast div{
	          text-transform:capitalize;
	          font-weight: 400;
	          font-size: 15px!important;
	          width: auto;
	          background: #ffffff!important;
	          border-radius:5px!important;
	          color: #111111!important;
	       }
		   
		   #Process div:hover, #Process div:hover div,
	       #Back div:hover, #Back div:hover div,
		   #Current div:hover, #Current div:hover div,
	       #Reset div:hover, #Reset div:hover div,
	       #Next div:hover, #Next div:hover div,
	       #NextLast div:hover, #NextLast div:hover div{
	           background: #dddddd!important;
	       }
	
		   #Process img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-process.png")!important;
	       }	
	       #Back img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-back.png")!important;
	       }
	       #Reset img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-reset.png")!important;  
	       }
	       #Next img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-next.png")!important;  
	       }
	       #NextLast img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-last.png")!important;
	       }
	</style>
</cfif>

<cfif Attributes.Theme eq "lightblue">

	<style>
		   #Process,
	       #Back,
	       #Reset,
	       #Next,
	       #NextLast{
	          margin-right: 10px;
	          border-radius:5px!important;
	       }
	       
		   #Process div,
	       #Back div,
	       #Reset div,
	       #Next div,
	       #NextLast div{
	          text-transform:capitalize;
	          font-weight: 400;
	          font-size: 15px!important;
	          width: auto;
	          background: #438fd6!important;
	          border-radius:5px!important;
	          color: #ffffff!important;
	       }
	       
		   #Process img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-process_white.png")!important;
	       }
	       #Back img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-back_white.png")!important;
	       }
	       #Reset img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-reset_white.png")!important;  
	       }
	       #Next img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-next_white.png")!important;  
	       }
	       #NextLast img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-last_white.png")!important;
	       }
		   
		   #Process div:hover, #Process div:hover div,
		   #Back div:hover, #Back div:hover div,
	       #Reset div:hover, #Reset div:hover div,
	       #Next div:hover, #Next div:hover div,
	       #NextLast div:hover, #NextLast div:hover div{
	           background: #dddddd!important;
			   color:#438fd6!important;
	       }
		   
		   #Process:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-process_lightblue.png")!important;
	       }
		   #Back:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-back_lightblue.png")!important;
	       }
	       #Reset:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-reset_lightblue.png")!important;  
	       }
	       #Next:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-next_lightblue.png")!important;  
	       }
	       #NextLast:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-last_lightblue.png")!important;
	       }
		   
		   
	</style>

</cfif>

<cfif Attributes.Theme eq "blue">

<style>
		   #Process,	
	       #Back,
	       #Reset,
	       #Next,
	       #NextLast{
	          margin-right: 10px;
	          border-radius:5px!important;
	       }
	       
		   #Process div,
	       #Back div,
	       #Reset div,
	       #Next div,
	       #NextLast div{
	          text-transform:capitalize;
	          font-weight: 400;
	          font-size: 15px!important;
	          width: auto;
	          background: #033f5d!important;
	          border-radius:5px!important;
	          color: #ffffff!important;
	       }
	       
		   #Process img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-process_white.png")!important;
	       }
	       #Back img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-back_white.png")!important;
	       }
	       #Reset img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-reset_white.png")!important;  
	       }
	       #Next img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-next_white.png")!important;  
	       }
	       #NextLast img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-last_white.png")!important;
	       }
		   
		   #Process div:hover, #Process div:hover div,
		   #Back div:hover, #Back div:hover div,
	       #Reset div:hover, #Reset div:hover div,
	       #Next div:hover, #Next div:hover div,
	       #NextLast div:hover, #NextLast div:hover div{
	           background: #dddddd!important;
			   color:#033f5d!important;
	       }
		   
		   #Process:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-process_blue.png")!important;
	       }
		   #Back:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-back_blue.png")!important;
	       }
	       #Reset:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-reset_blue.png")!important;  
	       }
	       #Next:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-next_blue.png")!important;  
	       }
	       #NextLast:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-last_blue.png")!important;
	       }
		   
		   
	</style>

</cfif>

<cfif Attributes.Theme eq "white">
<style>
	       #Process,
		   #Back,
	       #Reset,
	       #Next,
	       #NextLast{
	          margin-right: 10px;
	          border-radius:5px!important;
	       }
	       
		   #Process div,
	       #Back div,
	       #Reset div,
	       #Next div,
	       #NextLast div{
	          text-transform:capitalize;
	          font-weight: 400;
	          font-size: 15px!important;
	          width: auto;
	          background: #ffffff!important;
	          border-radius:5px!important;
	          color: #4d4d4d!important;
	       }
	       
		   #Process img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-process_gray.png")!important;
	       }
	       #Back img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-back_gray.png")!important;
	       }
	       #Reset img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-reset_gray.png")!important;  
	       }
	       #Next img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-next_gray.png")!important;  
	       }
	       #NextLast img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-last_gray.png")!important;
	       }
		   
		   #Process div:hover, #Process div:hover div,
		   #Back div:hover, #Back div:hover div,
	       #Reset div:hover, #Reset div:hover div,
	       #Next div:hover, #Next div:hover div,
	       #NextLast div:hover, #NextLast div:hover div{
	           background: #4d4d4d!important;
			   color:#ffffff!important;
	       }
		   
		   #Process:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-process_white.png")!important;
	       }
		   #Back:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-back_white.png")!important;
	       }
	       #Reset:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-reset_white.png")!important;  
	       }
	       #Next:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-next_white.png")!important;  
	       }
	       #NextLast:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-last_white.png")!important;
	       }
		   
		   
	</style>
</cfif>

<cfif Attributes.Theme eq "gray">
<style>
		   #Process,
	       #Back,
	       #Reset,
	       #Next,
	       #NextLast{
	          margin-right: 10px;
	          border-radius:5px!important;
	       }
	       
		   #Process div,
	       #Back div,
	       #Reset div,
	       #Next div,
	       #NextLast div{
	          text-transform:capitalize;
	          font-weight: 400;
	          font-size: 15px!important;
	          width: auto;
	          background: #4d4d4d!important;
	          border-radius:5px!important;
	          color: #ffffff!important;
	       }
	       
	       #Process img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-process_white.png")!important;
	       }
	       #Back img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-back_white.png")!important;
	       }
	       #Reset img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-reset_white.png")!important;  
	       }
	       #Next img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-next_white.png")!important;  
	       }
	       #NextLast img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-last_white.png")!important;
	       }
		   
		   #Process div:hover, #Process div:hover div,
		   #Back div:hover, #Back div:hover div,
	       #Reset div:hover, #Reset div:hover div,
	       #Next div:hover, #Next div:hover div,
	       #NextLast div:hover, #NextLast div:hover div{
	           background: #ffffff!important;
			   color:#4d4d4d!important;
	       }
		   
		   #Process:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-process_gray.png")!important;
	       }
		   #Back:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-back_gray.png")!important;
	       }
	       #Reset:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-reset_gray.png")!important;  
	       }
	       #Next:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-next_gray.png")!important;  
	       }
	       #NextLast:hover img{
	           content:url("../../../../../Images/Logos/PAS/nav-flat-save-last_gray.png")!important;
	       }
		   
		   
	</style>
</cfif>