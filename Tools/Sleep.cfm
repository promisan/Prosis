<!--- sleep custom tag
- causes CF to halt your program for specified number of seconds (does NOT halt the entire server)
- expected attribute: sleep (specified in seconds)
- example: <cf_sleep seconds="n"> 

- by Charlie Arehart, carehart@systemanage.com
--->

<cfparam name="attributes.seconds" default="2">
<cfobject type="JAVA" name="obj" class="java.lang.Thread" action="CREATE">

<cfset obj.sleep(#evaluate(attributes.seconds*10)#)>
