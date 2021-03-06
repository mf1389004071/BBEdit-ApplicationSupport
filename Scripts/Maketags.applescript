-- Maketags
--
-- Builds ctags file for currently active project
--
-- Installation:
-- 
-- Copy script to either location:
--   ~/Library/Application Support/BBEdit/Scripts
--   ~/Dropbox/Application Support/BBEdit/Scripts
--
-- To add a shortcut key:
--
--	 Window -> Palettes -> Scripts
--	 Select Maketags and click Set Key ...
--	 Enter a shortcut key combination (recommend Command + Option + T)
--
-- Author:  Andrew Carter <ascarter@gmail.com>
-- Version: 0.1
--
-- Copyright (c) 2011 Andrew Carter
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--

on makeTags()
	set theFile to missing value
	
	tell application "BBEdit"
		set activeWindow to front window
		
		if (class of activeWindow is project window) then
			set projectDocument to project document of activeWindow
			
			if ((count of items of projectDocument) > 0) then
				set firstFileItem to item 1 of projectDocument as alias
			else
				set firstFileItem to file of document of activeWindow as alias
			end if
			
			if (on disk of projectDocument) then
				set theProjectFile to file of projectDocument as alias
				
				tell application "Finder"
					set theProjectDir to container of theProjectFile
					set firstFileDir to container of firstFileItem
				end tell
				
				if (firstFileDir is equal to theProjectDir) then
					-- Use project file
					set theFile to theProjectDir as alias
				else
					-- External project file -> use first item to set context
					set theFile to firstFileItem
				end if
			else
				-- BBEdit doesn't provide direct access to the Instaproject root
				-- Use the first node from the project list
				set theFile to firstFileItem
			end if
		end if
	end tell
	
	if theFile is equal to missing value then
		-- No base file found for reference
		-- Signal error by beep and end
		beep
	else
		-- Run the maketags script
		set thePath to POSIX path of theFile
		set cmd to "cd " & thePath & "; /usr/local/bin/bbedit --maketags"
		do shell script cmd
	end if
end makeTags

makeTags()