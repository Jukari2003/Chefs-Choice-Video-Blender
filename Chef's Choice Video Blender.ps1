################################################################################
#                      Chef's Choice Video Blender                             #
#                     Written By: MSgt Anthony Brechtel                        #
#                                                                              #
################################################################################
######Load Assemblies###########################################################
clear-host
Add-Type -AssemblyName 'System.Windows.Forms'
Add-Type -AssemblyName 'System.Drawing'
Add-Type -AssemblyName 'PresentationFramework'
[System.Windows.Forms.Application]::EnableVisualStyles();
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

################################################################################
######Global Variables##########################################################
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Set-Location $dir

$script:program_title = "Chef's Choice Video Blender"
$script:version = "1.0"

$script:settings = @{}

################################################################################
######Main######################################################################
function main
{
    ##################################################################################
    ###########Main Form
    $Form = New-Object System.Windows.Forms.Form
    $Form.Location = "200, 200"
    $Form.Font = "Copperplate Gothic,8.1"
    $Form.FormBorderStyle = "Sizable"
    $Form.MinimumSize = "1000,800"
    $Form.ForeColor = "Black"
    $Form.BackColor = "#434343"
    $Form.Text = "  $script:program_title"
    $Form.AutoScaleMode = "Font"
    $Form.Width = 1000 #1245
    $Form.Height = 800

    $rip_to_frames_submit_button = New-Object System.Windows.Forms.Button
    ##################################################################################
    ###########Title Main
    $y_pos = 15
    $title1            = New-Object System.Windows.Forms.Label   
    $title1.Font       = New-Object System.Drawing.Font("Copperplate Gothic Bold",21,[System.Drawing.FontStyle]::Regular)
    $title1.anchor = "Top"
    $title1.Text       = $script:program_title
    $title1.TextAlign  = "MiddleCenter"
    $title1.Width      = $Form.Width
    $title1.height     = 35
    $title1.ForeColor  = "white"
    $title1.Location   = New-Object System.Drawing.Size((($Form.width / 2) - ($Form.width / 2)),$y_pos)
    $Form.Controls.Add($title1)

    ##################################################################################
    ###########Title Written By
    $y_pos = $y_pos + 30
    $title2            = New-Object System.Windows.Forms.Label
    $title2.Font       = New-Object System.Drawing.Font("Copperplate Gothic",7.5,[System.Drawing.FontStyle]::Regular)
    $title2.anchor = "Top"
    $title2.Text       = "Written by: Anthony Brechtel`nVer $script:version"
    $title2.TextAlign  = "MiddleCenter"
    $title2.ForeColor  = "darkgray"
    $title2.Width      = $Form.Width
    $title2.Height     = 40
    $title2.Location   = New-Object System.Drawing.Size((($Form.width / 2) - ($Form.width / 2)),$y_pos)
    $Form.Controls.Add($title2)

    ##################################################################################
    ###########Separator Bar 1
    $y_pos = $y_pos + 80;
    $separator_bar1                             = New-Object system.Windows.Forms.Label
    $separator_bar1.text                        = ""
    $separator_bar1.AutoSize                    = $false
    $separator_bar1.BorderStyle                 = "fixed3d"
    $separator_bar1.Anchor                      = 'top'
    $separator_bar1.width                       = ($Form.Width - 80)
    $separator_bar1.height                      = 1
    $separator_bar1.location                    = New-Object System.Drawing.Point((($Form.width / 2) - ($separator_bar1.width / 2) - 10),$y_pos)
    $separator_bar1.TextAlign                   = 'MiddleCenter'
    $Form.controls.Add($separator_bar1);

    ##################################################################################
    ###########Rip Title
    $rip_title_label = New-Object System.Windows.Forms.Label
    $rip_title_label.Location = New-Object System.Drawing.Point((($Form.width / 2) - ($Form.width / 2)),$y_pos)
    $rip_title_label.anchor = "Top"
    $rip_title_label.Width = $Form.Width
    $rip_title_label.height = 40
    $rip_title_label.ForeColor = "White" 
    $rip_title_label.Text = "Rip Video to Frames"
    $rip_title_label.TextAlign = "MiddleCenter"
    $rip_title_label.Font = [Drawing.Font]::New("Times New Roman", 15)
    $Form.Controls.Add($rip_title_label)


    ##################################################################################
    ###########Input Video Label
    $y_pos = $y_pos + 45
    $input_video_label = New-Object System.Windows.Forms.Label
    $input_video_label.Location = New-Object System.Drawing.Point(15, $y_pos)
    $input_video_label.anchor = "Top"
    $input_video_label.Size = "250, 23"
    $input_video_label.ForeColor = "White" 
    $input_video_label.Text = "Frames Input Video:"
    $input_video_label.TextAlign = "MiddleRight"
    $input_video_label.Font = [Drawing.Font]::New("Times New Roman", 12)
    $Form.Controls.Add($input_video_label)

    ##################################################################################
    ###########Input Video Box
    $input_video_box = New-Object System.Windows.Forms.TextBox
    $input_video_box.Location = New-Object System.Drawing.Point(($input_video_label.location.x + $input_video_label.width + 3),($y_pos))
    $input_video_box.font = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
    $input_video_box.anchor = "Top"
    $input_video_box.width = 500
    $input_video_box.Height = 40
    if(($script:settings['input_video'] -eq "") -or ($script:settings['input_video'] -eq $null) -or (!(Test-Path -literalpath $script:settings['input_video'])))
    {
        $input_video_box.text = "Browse or Enter a file path of Video"
    }
    else
    {
        $input_video_box.text = $script:settings['input_video']
        $input_video_label.ForeColor = "Green" 
    }
    $input_video_box.Add_Click({
        if($this.Text -eq "Browse or Enter a file path of Video")
        {
            $this.Text = ""
        }
    })
    $input_video_box.Add_TextChanged({
        
            if(($this.text -ne $Null) -and ($this.text -ne "") -and (Test-Path -literalpath $this.text))
            {
                $input_video_label.ForeColor = "Green" 
                $script:settings['input_video'] = $input_video_box.Text
                update_settings
            }
            else
            {
                $script:settings['input_video'] = "";
                $input_video_label.ForeColor = "White" 
                update_settings
            }
    })
    $input_video_box.Add_lostFocus({

        if(($script:settings['input_video'] -eq "") -or ($script:settings['input_video'] -eq $null) -or (!(Test-Path -literalpath $script:settings['input_video'])))
        {
            $this.text = "Browse or Enter a file path of Video"
        }
    })
    
    $Form.Controls.Add($input_video_box)

    ##################################################################################
    ###########Browse Button 1
    $browse_button1 = New-Object System.Windows.Forms.Button
    $browse_button1.Location= New-Object System.Drawing.Size(($input_video_box.location.x + $input_video_box.width + 3),($y_pos + 1))
    $browse_button1.BackColor = "#606060"
    $browse_button1.ForeColor = "White"
    $browse_button1.anchor = "Top"
    $browse_button1.Width=70
    $browse_button1.Height=22
    $browse_button1.Text='Browse'
    $browse_button1.Font = [Drawing.Font]::New("Times New Roman", 9)
    $browse_button1.Add_Click(
    {    
        $return = prompt_for_file
        if($return.length -ge 3)
        {
            $input_video_box.text = $return
        }
    })
    $Form.Controls.Add($browse_button1)


    ##################################################################################
    ###########Frames Output Label
    $y_pos = $y_pos + 45
    $output_frames_dir_label = New-Object System.Windows.Forms.Label
    $output_frames_dir_label.Location = New-Object System.Drawing.Point(15, $y_pos)
    $output_frames_dir_label.anchor = "Top"
    $output_frames_dir_label.Size = "250, 23"
    $output_frames_dir_label.ForeColor = "White" 
    $output_frames_dir_label.Text = "Frames Output Dir:"
    $output_frames_dir_label.TextAlign = "MiddleRight"
    $output_frames_dir_label.Font = [Drawing.Font]::New("Times New Roman", 12)
    $Form.Controls.Add($output_frames_dir_label)

    ##################################################################################
    ###########Output Video Box
    $output_frames_dir_box = New-Object System.Windows.Forms.TextBox
    $output_frames_dir_box.Location = New-Object System.Drawing.Point(($output_frames_dir_label.location.x + $output_frames_dir_label.width + 3),($y_pos))
    $output_frames_dir_box.font = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
    $output_frames_dir_box.anchor = "Top"
    $output_frames_dir_box.width = 500
    $output_frames_dir_box.Height = 40
    if(($script:settings['output_frames_dir'] -eq "") -or ($script:settings['output_frames_dir'] -eq $null) -or (!(Test-Path -literalpath $script:settings['output_frames_dir'])))
    {
        $output_frames_dir_box.Text = "Browse or Enter a file path"
    }
    else
    {
        $output_frames_dir_box.Text = $script:settings['output_frames_dir']
        $output_frames_dir_label.ForeColor = "Green" 
    }
    $output_frames_dir_box.Add_Click({
        if($this.Text -eq "Browse or Enter a file path")
        {
            $this.Text = ""
        }
    })
    $output_frames_dir_box.Add_TextChanged({
        
            if(($this.text -ne $Null) -and ($this.text -ne "") -and (Test-Path -literalpath $this.text))
            {
                $script:settings['output_frames_dir'] = $output_frames_dir_box.Text
                $output_frames_dir_label.ForeColor = "Green" 
                update_settings
            }
            else
            {
                
                $script:settings['output_frames_dir'] = "";
                $output_frames_dir_label.ForeColor = "White" 
                update_settings
            }
    })
    $output_frames_dir_box.Add_lostFocus({
        if(($this.text -eq "") -or ($this.text -eq $null) -or (!(Test-Path -literalpath $this.text)))
        {
            $this.text = "Browse or Enter a file path"
            $script:settings['output_frames_dir'] = "";
        }
    })
    
    $Form.Controls.Add($output_frames_dir_box)
    
    ##################################################################################
    ###########Output Dir Browse
    $output_frames_browse_btn = New-Object System.Windows.Forms.Button
    $output_frames_browse_btn.Location= New-Object System.Drawing.Size(($output_frames_dir_box.location.x + $output_frames_dir_box.width + 3),($y_pos + 1))
    $output_frames_browse_btn.BackColor = "#606060"
    $output_frames_browse_btn.ForeColor = "White"
    $output_frames_browse_btn.anchor = "Top"
    $output_frames_browse_btn.Width=70
    $output_frames_browse_btn.Height=22
    $output_frames_browse_btn.Text='Browse'
    $output_frames_browse_btn.Font = [Drawing.Font]::New("Times New Roman", 9)
    $output_frames_browse_btn.Add_Click(
    {    
        $return = prompt_for_folder
        if($return.length -ge 3)
        {
            $output_frames_dir_box.text = $return
        }
    })
    $Form.Controls.Add($output_frames_browse_btn)

    ##################################################################################
    ###########ffmpeg Location Label
    $y_pos = $y_pos + 45
    $ffmpeg_location_label1 = New-Object System.Windows.Forms.Label 
    $ffmpeg_location_label1.Location = New-Object System.Drawing.Point(15,($y_pos))
    $ffmpeg_location_label1.Size = "250, 23"
    $ffmpeg_location_label1.anchor = "Top"
    $ffmpeg_location_label1.ForeColor = "White"
    $ffmpeg_location_label1.Text = "FFmpeg Location:   "
    $ffmpeg_location_label1.TextAlign  = "MiddleRight"
    $ffmpeg_location_label1.Font = [Drawing.Font]::New("Times New Roman", 12)
    $form.Controls.Add($ffmpeg_location_label1)

    ##################################################################################
    ###########Scan Directory Input
    $ffmpeg_box1 = New-Object System.Windows.Forms.TextBox
    $ffmpeg_box2 = New-Object System.Windows.Forms.TextBox
    $ffmpeg_box1.Location = New-Object System.Drawing.Point(($ffmpeg_location_label1.location.x + $ffmpeg_location_label1.width + 3),($y_pos))
    $ffmpeg_box1.anchor = "Top"
    $ffmpeg_box1.width = 500
    $ffmpeg_box1.Height = 40
    $ffmpeg_box1.font = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
    if(($script:settings['ffmpeg'] -eq "") -or ($script:settings['ffmpeg'] -eq $null) -or (!(Test-Path -literalpath $script:settings['ffmpeg'])))
    {
        $ffmpeg_box1.text = "Browse or Enter a file path for FFmpeg.exe"
    }
    else
    {
        $ffmpeg_box1.text = $script:settings['ffmpeg']
        $ffmpeg_location_label1.ForeColor = "Green"
    }
    $ffmpeg_box1.Add_Click({
        if($ffmpeg_box1.Text -eq "Browse or Enter a file path for FFmpeg.exe")
        {
            $ffmpeg_box1.Text = ""
            $ffmpeg_box2.Text = ""
        }
    })
    $ffmpeg_box1.Add_TextChanged({
        
            if(($this.text -ne $Null) -and ($this.text -ne "") -and (Test-Path -literalpath $this.text) -and ($this.text -match ".exe$"))
            {
                $script:settings['ffmpeg'] = $ffmpeg_box1.Text
                $ffmpeg_box2.Text = $script:settings['ffmpeg']
                $ffmpeg_location_label1.ForeColor = "Green"
                update_settings
            }
            else
            {
                $script:settings['ffmpeg'] = "";
                $ffmpeg_location_label1.ForeColor = "White"
                update_settings
            }
    })
    $ffmpeg_box1.Add_lostFocus({

        if(($script:settings['ffmpeg'] -eq "") -or ($script:settings['ffmpeg'] -eq $null) -or (!(Test-Path -literalpath $script:settings['ffmpeg'])))
        {
            $this.text = "Browse or Enter a file path for FFmpeg.exe"
            $ffmpeg_box2.Text = "Browse or Enter a file path for FFmpeg.exe"
        }
    })
    $form.Controls.Add($ffmpeg_box1)
    
    ##################################################################################
    ###########Browse Button 1
    $browse_button3 = New-Object System.Windows.Forms.Button
    $browse_button3.Location= New-Object System.Drawing.Size(($ffmpeg_box1.location.x + $ffmpeg_box1.width + 3),($y_pos + 1))
    $browse_button3.BackColor = "#606060"
    $browse_button3.ForeColor = "White"
    $browse_button3.anchor = "Top"
    $browse_button3.Width=70
    $browse_button3.Height=22
    $browse_button3.Text='Browse'
    $browse_button3.Font = [Drawing.Font]::New("Times New Roman", 9)
    $browse_button3.Add_Click(
    {    
        $return = prompt_for_file_exe
        if($return.length -ge 3)
        {
            $ffmpeg_box1.text = $return
        }
    })
    $Form.Controls.Add($browse_button3)


    ##################################################################################
    ###########FPS Label
    $y_pos = $y_pos + 45
    $rip_fps_label1 = New-Object System.Windows.Forms.Label 
    $rip_fps_label1.Location = New-Object System.Drawing.Point(15,($y_pos))
    $rip_fps_label1.Size = "250, 23"
    $rip_fps_label1.anchor = "Top"
    $rip_fps_label1.ForeColor = "White"
    $rip_fps_label1.Text = "Frames Per Second:   "
    $rip_fps_label1.TextAlign  = "MiddleRight"
    $rip_fps_label1.Font = [Drawing.Font]::New("Times New Roman", 12)
    $form.Controls.Add($rip_fps_label1)



    ##################################################################################
    ###########Framerate Slider
    $rip_fps_status1 = New-Object System.Windows.Forms.Label 
    $rip_fps_trackbar1 = New-Object System.Windows.Forms.TrackBar
    $rip_fps_trackbar1.anchor = "Top"
    $rip_fps_trackbar1.Width = 500
    $rip_fps_trackbar1.Location = New-Object System.Drawing.Size(($rip_fps_label1.location.x + $rip_fps_label1.width + 3),($y_pos - 10))
    $rip_fps_trackbar1.Orientation = "Horizontal"

    $rip_fps_trackbar1.Height = 40
    $rip_fps_trackbar1.TickFrequency = 1
    $rip_fps_trackbar1.TickStyle = "TopLeft"
    $rip_fps_trackbar1.SetRange(1, 60)
    if(($script:settings['rip_fps'] -ne "") -and ($script:settings['rip_fps'] -ne $null))
    {
        $rip_fps_trackbar1.Value = $script:settings['rip_fps']
    }
    else
    {
        $rip_fps_trackbar1.Value = 15
        $script:settings['rip_fps'] = 15
    }
    $rip_fps_trackbar1.add_ValueChanged({
        $rip_fps_trackbar1Value = $rip_fps_trackbar1.Value
        $rip_fps_status1.Text = $rip_fps_trackbar1Value
        $script:settings['rip_fps'] = $rip_fps_trackbar1Value
        update_settings
        
    })
    $Form.Controls.add($rip_fps_trackbar1)

    ##################################################################################
    ###########FPS Status Label
    $rip_fps_status1.Location = New-Object System.Drawing.Point(($rip_fps_trackbar1.location.x + $rip_fps_trackbar1.width + 3),($y_pos + 1))
    $rip_fps_status1.Size = "250, 23"
    $rip_fps_status1.anchor = "Top"
    $rip_fps_status1.ForeColor = "White"
    $rip_fps_status1.Text = $rip_fps_trackbar1.Value
    $rip_fps_status1.TextAlign  = "MiddleLeft"
    $rip_fps_status1.Font = [Drawing.Font]::New("Times New Roman", 12)
    $form.Controls.Add($rip_fps_status1)


    #################################################################################  
    ###########Rip To Frames Submit Button
    $y_pos = $y_pos + 45
    $rip_to_frames_submit_button = New-Object System.Windows.Forms.Button
    $rip_to_frames_submit_button.Location= New-Object System.Drawing.Size((($Form.width / 2) - 100),($y_pos))
    $rip_to_frames_submit_button.anchor = "Top"
    $rip_to_frames_submit_button.BackColor = "#606060"
    $rip_to_frames_submit_button.ForeColor = "White"
    $rip_to_frames_submit_button.Width=200
    $rip_to_frames_submit_button.Height=25
    $rip_to_frames_submit_button.Text='Rip-to-Frames'
    $rip_to_frames_submit_button.Add_Click({
        [array]$errors = "";
        if(($script:settings['input_video'] -eq "") -or ($script:settings['input_video'] -eq $null) -or (!(Test-path -LiteralPath $script:settings['input_video'])))
        {
            $errors += "Frames Input Video must be provided for frame ripping."
        }
        if(($script:settings['output_frames_dir'] -eq "") -or ($script:settings['output_frames_dir'] -eq $null) -or (!(Test-path -LiteralPath $script:settings['output_frames_dir'])))
        {
            $errors += "Frames Output Directory must be provided for frame ripping."
        }
        if(($script:settings['ffmpeg'] -eq "") -or ($script:settings['ffmpeg'] -eq $null) -or (!(Test-path -LiteralPath $script:settings['ffmpeg'])))
        {
            Start-Process "https://ffmpeg.org/download.html#build-windows"
            $errors += "FFMpeg Location must be provided for frame ripping"
        }
        if($errors.count -eq 1)
        {
            $continue = 1;
            if((Get-ChildItem -literalpath $script:settings['output_frames_dir'] | Measure-Object).Count -gt 0)
            {
                $message = "Output Directory is NOT empty! `n`nAll .PNG files in:`n `"" + $script:settings['output_frames_dir'] + "`"`nWILL BE DELETED!!! `n`nContinue?`n`n"
                $yesno = [System.Windows.Forms.MessageBox]::Show("$message","WARNING!!!", "YesNo" , "Information" , "Button1")
                if($yesno -eq "No")
                {
                    $continue = 0;
                }
            }
            if($continue -eq 1)
            {
                rip_to_frames $script:settings['input_video'] $script:settings['output_frames_dir'] $script:settings['rip_fps']
                $message = "Frame Generation Finished!"
                [System.Windows.MessageBox]::Show($message,"Finished!",'Ok')
                Start-Process $script:settings['output_frames_dir']
            }
            
        }
        else
        {
            $message = "Please fix the following errors:`n`n"
            $counter = 0;
            foreach($error in $errors)
            {
                if($error -ne "")
                {
                    $counter++;
                    $message = $message + "$counter - $error`n"
                } 
            }
            [System.Windows.MessageBox]::Show($message,"Error",'Ok','Error')
        }
     })
    $Form.controls.Add($rip_to_frames_submit_button)
    ####################################################################################################################################################################
    ####################################################################################################################################################################
    ####################################################################################################################################################################
    ####################################################################################################################################################################
    ###########Separator Bar 2
    $y_pos = $y_pos + 40;
    $separator_bar2                             = New-Object system.Windows.Forms.Label
    $separator_bar2.text                        = ""
    $separator_bar2.AutoSize                    = $false
    $separator_bar2.BorderStyle                 = "fixed3d"
    $separator_bar2.Anchor                      = 'top'
    $separator_bar2.width                       = ($Form.Width - 80)
    $separator_bar2.height                      = 1
    $separator_bar2.location                    = New-Object System.Drawing.Point((($Form.width / 2) - ($separator_bar2.width / 2) - 10),$y_pos)
    $separator_bar2.TextAlign                   = 'MiddleCenter'
    $Form.controls.Add($separator_bar2);


    ##################################################################################
    ###########Merge Main Title
    $merge_title_label = New-Object System.Windows.Forms.Label
    $merge_title_label.Location = New-Object System.Drawing.Point((($Form.width / 2) - ($Form.width / 2)),$y_pos)
    $merge_title_label.anchor = "Top"
    $merge_title_label.Width = $Form.Width
    $merge_title_label.height = 40
    $merge_title_label.ForeColor = "White" 
    $merge_title_label.Text = "Merge Frames to Video"
    $merge_title_label.TextAlign = "MiddleCenter"
    $merge_title_label.Font = [Drawing.Font]::New("Times New Roman", 15)
    $Form.Controls.Add($merge_title_label)


    ##################################################################################
    ###########Frames Input Directory Label
    $y_pos = $y_pos + 45
    $input_frames_label = New-Object System.Windows.Forms.Label
    $input_frames_label.Location = New-Object System.Drawing.Point(15, $y_pos)
    $input_frames_label.anchor = "Top"
    $input_frames_label.Size = "250, 23"
    $input_frames_label.ForeColor = "White" 
    $input_frames_label.Text = "Frames Input Dir:"
    $input_frames_label.TextAlign = "MiddleRight"
    $input_frames_label.Font = [Drawing.Font]::New("Times New Roman", 12)
    $Form.Controls.Add($input_frames_label)


    ##################################################################################
    ###########Frames Input Directory Box
    $size_scaler_trackbar = New-Object System.Windows.Forms.TrackBar
    $output_width_box = New-Object System.Windows.Forms.TextBox
    $output_height_box = New-Object System.Windows.Forms.TextBox
    $input_frames_box = New-Object System.Windows.Forms.TextBox
    $input_frames_box.Location = New-Object System.Drawing.Point(($input_frames_label.location.x + $input_frames_label.width + 3),($y_pos))
    $input_frames_box.font = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
    $input_frames_box.anchor = "Top"
    $input_frames_box.width = 500
    $input_frames_box.Height = 40
    $input_frames_box.Text = $script:settings['input_frames_dir']
    if(($script:settings['input_frames_dir'] -eq "") -or ($script:settings['input_frames_dir'] -eq $null) -or (!(Test-Path -literalpath $script:settings['input_frames_dir'])))
    {
        $input_frames_box.text = "Browse or Enter a File Path of Frames Directory"
    }
    else
    {
        $input_frames_box.text = $script:settings['input_frames_dir']
        $input_frames_label.ForeColor = "Green"
    }
    $input_frames_box.Add_Click({
        if($this.Text -eq "Browse or Enter a File Path of Frames Directory")
        {
            $this.Text = ""
        }
    })
    $input_frames_box.Add_TextChanged({
        if(($this.text -ne "") -and (Test-Path -literalpath $this.text))
        {
            $dir_contents = Get-ChildItem -LiteralPath $this.text | where {$_.extension -in ".png",".jpg",".bmp",".jpeg"} | Select-Object -First 1
            #write-host $dir_contents
            if($dir_contents -ne $null)
            {
                $image = New-Object System.Drawing.Bitmap $dir_contents.FullName
                #write-host $dir_contents.fullname
                $width = $image.Width
                $height = $image.Height
                #write-host $width x $height
                if($width -ne "")
                {
                    
                    if($width -le $height)
                    {
                        $size_scaler_trackbar.value = $width
                        $size_scaler_trackbar.AccessibleName = $width
                        $size_scaler_trackbar.AccessibleDescription = $height
                    }
                    else
                    {
                        $size_scaler_trackbar.value = $height
                        $size_scaler_trackbar.AccessibleName = $width
                        $size_scaler_trackbar.AccessibleDescription = $height
                    }
                    $script:settings['input_frames_dir'] = $this.text
                    $output_width_box.text = $width
                    $output_height_box.text = $height
                    $script:settings['width'] = $width
                    $script:settings['height'] = $height
                    $input_frames_label.ForeColor = "Green"
                    update_settings
                }
            }
            else
            {
                $script:settings['input_frames_dir'] = ""
                $input_frames_label.ForeColor = "White"
                update_settings
            }
        }
        else
        {
            $script:settings['input_frames_dir'] = ""
            $input_frames_label.ForeColor = "White"
            update_settings
        }
    })
    $input_frames_box.Add_lostFocus({
        if(($script:settings['input_frames_dir'] -eq "") -or ($script:settings['input_frames_dir'] -eq $null) -or (!(Test-Path -literalpath $script:settings['input_frames_dir'])))
        {
            $this.text = "Browse or Enter a File Path of Frames Directory"
            $script:settings['input_frames_dir'] = "";
            $input_frames_label.ForeColor = "White"
        }
    })
    $Form.Controls.Add($input_frames_box)
    
    ##################################################################################
    ###########Frames Input Directory Browse
    $browse_button4 = New-Object System.Windows.Forms.Button
    $browse_button4.Location= New-Object System.Drawing.Size(($input_frames_box.location.x + $input_frames_box.width + 3),($y_pos + 1))
    $browse_button4.BackColor = "#606060"
    $browse_button4.ForeColor = "White"
    $browse_button4.anchor = "Top"
    $browse_button4.Width=70
    $browse_button4.Height=22
    $browse_button4.Text='Browse'
    $browse_button4.Font = [Drawing.Font]::New("Times New Roman", 9)
    $browse_button4.Add_Click(
    {    
		    [string]$script:settings['input_frames_dir'] = prompt_for_folder
            if(($script:settings['input_frames_dir'] -ne $Null) -and ($script:settings['input_frames_dir'] -ne "") -and ((Test-Path -literalpath $script:settings['input_frames_dir']) -eq $True))
            {
                $input_frames_box.Text= $script:settings['input_frames_dir']
                update_settings
                
            }
    })
    $Form.Controls.Add($browse_button4)


    ##################################################################################
    ###########Video Output Name Label
    $y_pos = $y_pos + 45
    $output_video_label = New-Object System.Windows.Forms.Label
    $output_video_label.Location = New-Object System.Drawing.Point(15, $y_pos)
    $output_video_label.anchor = "Top"
    $output_video_label.Size = "250, 23"
    $output_video_label.ForeColor = "White" 
    $output_video_label.Text = "Video Output Name:"
    $output_video_label.TextAlign = "MiddleRight"
    $output_video_label.Font = [Drawing.Font]::New("Times New Roman", 12)
    $Form.Controls.Add($output_video_label)


    ##################################################################################
    ###########Video Output Name Box
    $output_video_box = New-Object System.Windows.Forms.TextBox
    $output_video_box.Location = New-Object System.Drawing.Point(($output_video_label.location.x + $output_video_label.width + 3),($y_pos))
    $output_video_box.font = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
    $output_video_box.anchor = "Top"
    $output_video_box.width = 500
    $output_video_box.Height = 40
    if(($script:settings['output_video'] -eq "") -or ($script:settings['output_video'] -eq $null))
    {
        $output_video_box.text = "Enter Video Output Name & Extension"
    }
    else
    {
        $output_video_box.text = $script:settings['output_video']
        $output_video_label.ForeColor = "Green"
    }
    $output_video_box.Add_Click({
        if($this.Text -eq "Enter Video Output Name & Extension")
        {
            $this.Text = ""
        }
    })
    $output_video_box.Add_TextChanged({
        
        $base_folder = ""
        if($this.text -match "\\|:")
        {
            $base_folder = ""
            if(($this.text.length -ge 4) -and (Test-Path -LiteralPath $this.text -isvalid))
            {
                $base_folder = split-path($this.text)
                if(($base_folder -ne "") -and (Test-Path -LiteralPath $base_folder))
                {
                    $base_folder = $this.text
                }
                else
                {
                    $base_folder = ""
                }
            }
        }
        elseif(!($this.text.IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -eq -1))
        {
            $base_folder = ""
        }
        else
        {
            $base_folder = "$dir\" + $this.text
        }
        if((!(($this.text -eq "") -or ($this.text -eq $null) -or ($this.text -eq "Enter Video Output Name & Extension"))) -and ($base_folder -ne "") -and ($this.text -imatch ".avi$|.mp4$|.mpeg$|.mkv$|.rm$|.mpg$|.m4v$|.flv$|.wmv$|.mov$|.ogm$"))
        {
            $script:settings['output_video'] = $base_folder
            $this.text = $script:settings['output_video']
            $this.selectionstart = $this.text.length
            $output_video_label.ForeColor = "Green"
            update_settings
        }
        else
        {
            $output_video_label.ForeColor = "White"
            $script:settings['output_video'] = "";
            update_settings
        }
    })
    $output_video_box.Add_lostFocus({
        if(($this.text -eq "") -or ($this.text -eq $null) -or ($this.text -eq "Enter Video Output Name & Extension") -or ($script:settings['output_video'] -eq ""))
        {
                $this.text = "Enter Video Output Name & Extension"
                $script:settings['output_video'] = ""
                update_settings
        }
     })
    $Form.Controls.Add($output_video_box)


    ##################################################################################
    ###########Input Audio Label
    $y_pos = $y_pos + 45
    $input_audio_label = New-Object System.Windows.Forms.Label
    $input_audio_label.Location = New-Object System.Drawing.Point(15, $y_pos)
    $input_audio_label.anchor = "Top"
    $input_audio_label.Size = "250, 23"
    $input_audio_label.ForeColor = "White" 
    $input_audio_label.Text = "Audio Input Video:"
    $input_audio_label.TextAlign = "MiddleRight"
    $input_audio_label.Font = [Drawing.Font]::New("Times New Roman", 12)
    $Form.Controls.Add($input_audio_label)


    ##################################################################################
    ###########Input Audio Box
    $input_audio_box = New-Object System.Windows.Forms.TextBox
    $input_audio_box.Location = New-Object System.Drawing.Point(($input_audio_label.location.x + $input_audio_label.width + 3),($y_pos))
    $input_audio_box.font = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
    $input_audio_box.anchor = "Top"
    $input_audio_box.width = 500
    $input_audio_box.Height = 40
    if(($script:settings['input_audio'] -eq "") -or ($script:settings['input_audio'] -eq $null) -or (!(Test-Path -literalpath $script:settings['input_audio'])))
    {
        $input_audio_box.text = "Browse or Enter a file path of Video Containing Audio (Optional)"
    }
    else
    {
        $input_audio_box.text = $script:settings['input_audio']
        $input_audio_label.ForeColor = "Green" 
    }
    $input_audio_box.Add_Click({
        if($this.Text -eq "Browse or Enter a file path of Video Containing Audio (Optional)")
        {
            $this.Text = ""
        }
    })
    $input_audio_box.Add_TextChanged({
        
            if(($this.text -ne $Null) -and ($this.text -ne "") -and (Test-Path -literalpath $this.text))
            {
                $script:settings['input_audio'] = $input_audio_box.Text
                $input_audio_label.ForeColor = "Green" 
                update_settings
            }
            else
            {
                $script:settings['input_audio'] = "";
                $input_audio_label.ForeColor = "White"
                update_settings
            }
    })
    $input_audio_box.Add_lostFocus({

        if(($script:settings['input_audio'] -eq "") -or ($script:settings['input_audio'] -eq $null) -or (!(Test-Path -literalpath $script:settings['input_audio'])))
        {
            $this.text = "Browse or Enter a file path of Video Containing Audio (Optional)"
        }
    })
    
    $Form.Controls.Add($input_audio_box)


    ##################################################################################
    ###########Input Audio - Browse Button 6
    $browse_button5 = New-Object System.Windows.Forms.Button
    $browse_button5.Location= New-Object System.Drawing.Size(($input_audio_box.location.x + $input_audio_box.width + 3),($y_pos + 1))
    $browse_button5.BackColor = "#606060"
    $browse_button5.ForeColor = "White"
    $browse_button5.anchor = "Top"
    $browse_button5.Width=70
    $browse_button5.Height=22
    $browse_button5.Text='Browse'
    $browse_button5.Font = [Drawing.Font]::New("Times New Roman", 9)
    $browse_button5.Add_Click({    
        $return = prompt_for_audio
        if($return.length -ge 3)
        {
            $input_audio_box.text = $return
        }
    })
    $Form.Controls.Add($browse_button5)


    ##################################################################################
    ###########FFmpeg Location Label2
    $y_pos = $y_pos + 45
    $ffmpeg_location_label2 = New-Object System.Windows.Forms.Label 
    $ffmpeg_location_label2.Location = New-Object System.Drawing.Point(15,($y_pos))
    $ffmpeg_location_label2.Size = "250, 23"
    $ffmpeg_location_label2.anchor = "Top"
    $ffmpeg_location_label2.ForeColor = "White"
    $ffmpeg_location_label2.Text = "FFmpeg Location:   "
    $ffmpeg_location_label2.TextAlign  = "MiddleRight"
    $ffmpeg_location_label2.Font = [Drawing.Font]::New("Times New Roman", 12)
    $form.Controls.Add($ffmpeg_location_label2)


    ##################################################################################
    ###########FFmpeg Box2   
    $ffmpeg_box2.Location = New-Object System.Drawing.Point(($ffmpeg_location_label2.location.x + $ffmpeg_location_label2.width + 3),($y_pos))
    $ffmpeg_box2.anchor = "Top"
    $ffmpeg_box2.width = 500
    $ffmpeg_box2.Height = 40
    $ffmpeg_box2.font = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
    if(($script:settings['ffmpeg'] -eq "") -or ($script:settings['ffmpeg'] -eq $null) -or (!(Test-Path -literalpath $script:settings['ffmpeg'])))
    {
        $ffmpeg_box2.text = "Browse or Enter a file path for FFmpeg.exe"
    }
    else
    {
        $ffmpeg_box2.text = $script:settings['ffmpeg']
        $ffmpeg_location_label1.ForeColor = "Green"
        $ffmpeg_location_label2.ForeColor = "Green"
    }
    $ffmpeg_box2.Add_Click({
        if($ffmpeg_box2.Text -eq "Browse or Enter a file path for FFmpeg.exe")
        {
            $ffmpeg_box2.Text = ""
        }
    })
    $ffmpeg_box2.Add_TextChanged({
        
        if(($this.text -ne $Null) -and ($this.text -ne "") -and (Test-Path -literalpath $this.text) -and ($this.text -match ".exe$"))
        {
            $script:settings['ffmpeg'] = $ffmpeg_box2.Text
            $ffmpeg_box1.Text = $script:settings['ffmpeg']
            $ffmpeg_location_label1.ForeColor = "Green"
            $ffmpeg_location_label2.ForeColor = "Green"
            update_settings
        }
        else
        {
            $script:settings['ffmpeg'] = "";
            $ffmpeg_location_label1.ForeColor = "White"
            $ffmpeg_location_label2.ForeColor = "White"
            update_settings
        }
    })
    $ffmpeg_box2.Add_lostFocus({
        if(($script:settings['ffmpeg'] -eq "") -or ($script:settings['ffmpeg'] -eq $null) -or (!(Test-Path -literalpath $script:settings['ffmpeg'])))
        {
            $this.text = "Browse or Enter a file path for FFmpeg.exe"
            $ffmpeg_box1.Text = "Browse or Enter a file path for FFmpeg.exe"
        }
    })
    $form.Controls.Add($ffmpeg_box2)
    

    ##################################################################################
    ###########FFMpeg - Browse Button 
    $browse_button6 = New-Object System.Windows.Forms.Button
    $browse_button6.Location= New-Object System.Drawing.Size(($ffmpeg_box2.location.x + $ffmpeg_box2.width + 3),($y_pos + 1))
    $browse_button6.BackColor = "#606060"
    $browse_button6.ForeColor = "White"
    $browse_button6.anchor = "Top"
    $browse_button6.Width=70
    $browse_button6.Height=22
    $browse_button6.Text='Browse'
    $browse_button6.Font = [Drawing.Font]::New("Times New Roman", 9)
    $browse_button6.Add_Click({    
        $return = prompt_for_file_exe
        if($return.length -ge 3)
        {
            $ffmpeg_box2.text = $return
        }
    })
    $Form.Controls.Add($browse_button6)


    ##################################################################################
    ###########Merge FPS Status Label 1
    $y_pos = $y_pos + 45
    $merge_fps_label2 = New-Object System.Windows.Forms.Label 
    $merge_fps_label2.Location = New-Object System.Drawing.Point(15,($y_pos))
    $merge_fps_label2.Size = "250, 23"
    $merge_fps_label2.anchor = "Top"
    $merge_fps_label2.ForeColor = "White"
    $merge_fps_label2.Text = "Frames Per Second:   "
    $merge_fps_label2.TextAlign  = "MiddleRight"
    $merge_fps_label2.Font = [Drawing.Font]::New("Times New Roman", 12)
    $form.Controls.Add($merge_fps_label2)


    ##################################################################################
    ###########Merge Framerate Slider
    $merge_fps_status2 = New-Object System.Windows.Forms.Label 
    $merge_fps_trackbar2 = New-Object System.Windows.Forms.TrackBar
    $merge_fps_trackbar2.anchor = "Top"
    $merge_fps_trackbar2.Width = 500
    $merge_fps_trackbar2.Location = New-Object System.Drawing.Size(($merge_fps_label2.location.x + $merge_fps_label2.width + 3),($y_pos - 10))
    $merge_fps_trackbar2.Orientation = "Horizontal"

    $merge_fps_trackbar2.Height = 40
    $merge_fps_trackbar2.TickFrequency = 1
    $merge_fps_trackbar2.TickStyle = "TopLeft"
    $merge_fps_trackbar2.SetRange(1, 60)
    if(($script:settings['merge_fps'] -ne "") -and ($script:settings['merge_fps'] -ne $null))
    {
        $merge_fps_trackbar2.Value = $script:settings['merge_fps']
    }
    else
    {
        $merge_fps_trackbar2.Value = 15
        $script:settings['merge_fps'] = 15
    }
    $merge_fps_trackbar2.add_ValueChanged({
        $merge_fps_trackbar2Value = $merge_fps_trackbar2.Value
        $merge_fps_status2.Text = $merge_fps_trackbar2Value
        $script:settings['merge_fps'] = $merge_fps_trackbar2Value
        update_settings
        
    })
    $Form.Controls.add($merge_fps_trackbar2)


    ##################################################################################
    ###########Merge FPS Status Label 2
    $merge_fps_status2.Location = New-Object System.Drawing.Point(($merge_fps_trackbar2.location.x + $merge_fps_trackbar2.width + 3),($y_pos + 1))
    $merge_fps_status2.Size = "250, 23"
    $merge_fps_status2.anchor = "Top"
    $merge_fps_status2.ForeColor = "White"
    $merge_fps_status2.Text = $merge_fps_trackbar2.Value
    $merge_fps_status2.TextAlign  = "MiddleLeft"
    $merge_fps_status2.Font = [Drawing.Font]::New("Times New Roman", 12)
    $form.Controls.Add($merge_fps_status2)


    ##################################################################################
    ###########Ouput Video Label
    $y_pos = $y_pos + 45
    $output_dim_label = New-Object System.Windows.Forms.Label
    $output_dim_label.Location = New-Object System.Drawing.Point(15, $y_pos)
    $output_dim_label.anchor = "Top"
    $output_dim_label.Size = "250, 23"
    $output_dim_label.ForeColor = "White" 
    $output_dim_label.Text = "Output Width x Height:"
    $output_dim_label.TextAlign = "MiddleRight"
    $output_dim_label.Font = [Drawing.Font]::New("Times New Roman", 12)
    $Form.Controls.Add($output_dim_label)


    ##################################################################################
    ###########Output Width Box
    $output_width_box.Location = New-Object System.Drawing.Point(($output_dim_label.location.x + $output_dim_label.width + 3),($y_pos))
    $output_width_box.font = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
    $output_width_box.anchor = "Top"
    $output_width_box.width = 50
    $output_width_box.Height = 40
    $output_width_box.Text = $script:settings['width']
    $output_width_box.Add_TextChanged({
        if(($this.text -match "^\d+$") -and ($this.text -ge 1))
        {
            $script:settings['width'] = $this.text
            update_settings
        }
    })
    $output_width_box.Add_lostFocus({
        if((!($this.text -match "^\d+$")) -or ($this.text -le 1))
        {
            $this.text = $script:settings['width']
        }
        else
        {
            if($script:settings['width'] -le $script:settings['height'])
            {
                #$size_scaler_trackbar.value = $script:settings['width']
            }
            else
            {
                #$size_scaler_trackbar.value = $script:settings['height']
            }
        }
    })
    $Form.Controls.Add($output_width_box)


    ##################################################################################
    ###########Size X Label
    $size_x_label = New-Object System.Windows.Forms.Label
    $size_x_label.Location = New-Object System.Drawing.Point(($output_width_box.Location.x + $output_width_box.Width + 5), $y_pos)
    $size_x_label.anchor = "Top"
    $size_x_label.Size = "14, 23"
    $size_x_label.ForeColor = "White" 
    $size_x_label.Text = "x"
    $size_x_label.TextAlign = "MiddleCenter"
    $size_x_label.Font = [Drawing.Font]::New("Times New Roman", 12)
    $Form.Controls.Add($size_x_label)


    ##################################################################################
    ###########Output Height Box  
    $output_height_box.Location = New-Object System.Drawing.Point(($size_x_label.location.x + $size_x_label.height + 3),($y_pos))
    $output_height_box.font = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
    $output_height_box.anchor = "Top"
    $output_height_box.Width = 50
    $output_height_box.Height = 40
    $output_height_box.Text = $script:settings['height']
    $output_height_box.Add_TextChanged({
        if(($this.text -match "^\d+$") -and ($this.text -ge 1))
        {
            $script:settings['height'] = $this.text
            update_settings
        }
    })
    $output_height_box.Add_lostFocus({
        if((!($this.text -match "^\d+$")) -or ($this.text -le 1))
        {
            $this.text = $script:settings['height']

        }
        else
        {
            if($script:settings['width'] -le $script:settings['height'])
            {
                #$size_scaler_trackbar.value = $script:settings['width']
            }
            else
            {
                #$size_scaler_trackbar.value = $script:settings['height']
            }
        }
    })
    $Form.Controls.Add($output_height_box)


    ##################################################################################
    ###########Size Scale Label
    $size_scale_label = New-Object System.Windows.Forms.Label
    $size_scale_label.Location = New-Object System.Drawing.Point(($output_height_box.Location.x + $output_height_box.width + 20), $y_pos)
    $size_scale_label.anchor = "Top"
    $size_scale_label.Size = "100, 23"
    $size_scale_label.ForeColor = "White" 
    $size_scale_label.Text = "Size Scaler:"
    $size_scale_label.TextAlign = "MiddleRight"
    $size_scale_label.Font = [Drawing.Font]::New("Times New Roman", 12)
    $Form.Controls.Add($size_scale_label)


    ##################################################################################
    ###########Size Scaler Trackbar
    $size_scaler_trackbar.anchor = "Top"
    $size_scaler_trackbar.Width = 250
    $size_scaler_trackbar.Location = New-Object System.Drawing.Size(($size_scale_label.location.x + $size_scale_label.width + 3),($y_pos - 10))
    $size_scaler_trackbar.Orientation = "Horizontal"
    $size_scaler_trackbar.Height = 30
    $size_scaler_trackbar.TickFrequency = 100
    $size_scaler_trackbar.TickStyle = "TopLeft"
    $size_scaler_trackbar.SetRange(50, 5000)
    $size_scaler_trackbar.AccessibleName = $script:settings['width'];       #Width
    $size_scaler_trackbar.AccessibleDescription = $script:settings['height'] #Height
    if(($script:settings['width'] -ne $null) -and ($script:settings['height'] -ne $null))
    {
        if($script:settings['width'] -le $script:settings['height'])
        {
            $size_scaler_trackbar.Value = $script:settings['width']
        }
        else
        {
            $size_scaler_trackbar.Value = $script:settings['height']
        }
    }
    else
    {
        $size_scaler_trackbar.Value = 1080
    }
    $size_scaler_trackbar.add_ValueChanged({

         #write-host Start1: $script:settings['width'] x $script:settings['height'] 
         #write-host "Start2" $size_scaler_trackbar.AccessibleName "x" $size_scaler_trackbar.AccessibleDescription
         if([int]$size_scaler_trackbar.AccessibleName -le [int]$size_scaler_trackbar.AccessibleDescription) #Width -le Height
         {
            $script:settings['width'] = $size_scaler_trackbar.Value
            if($script:settings['width'] -ge $size_scaler_trackbar.AccessibleName)
            {
                #write-host Set1
                [int]$distance = [int]$script:settings['width'] - [int]$size_scaler_trackbar.AccessibleName
                [int]$script:settings['height'] = [int]$size_scaler_trackbar.AccessibleDescription + [int]$distance
                #write-host I1 $distance - $script:settings['width'] x $script:settings['height']
                $output_height_box.text = $script:settings['height']
                $output_width_box.text = $script:settings['width'] 
            }
            else
            {
                #write-host Set2
                [int]$distance = [int]$size_scaler_trackbar.Accessiblename - [int]$script:settings['width']
                [int]$script:settings['height'] = [int]$size_scaler_trackbar.AccessibleDescription - [int]$distance
                #write-host D2 $distance - $script:settings['width'] x $script:settings['height']
                $output_height_box.text = $script:settings['height']
                $output_width_box.text = $script:settings['width']

            }
         }
         ##############################################################################################
         else
         {
            $script:settings['height'] = $size_scaler_trackbar.Value
            if($script:settings['height'] -ge $size_scaler_trackbar.AccessibleDescription)
            {
                #write-host Set3
                [int]$distance = [int]$script:settings['height'] - [int]$size_scaler_trackbar.AccessibleDescription
                [int]$script:settings['width'] = [int]$size_scaler_trackbar.AccessibleName + [int]$distance
                #write-host I3 $distance - $script:settings['width'] x $script:settings['height']
                $output_height_box.text = $script:settings['height']
                $output_width_box.text = $script:settings['width']
            }
            else
            {
                #write-host Set4
                [int]$distance = [int]$size_scaler_trackbar.AccessibleDescription - [int]$script:settings['height']
                [int]$script:settings['width'] = [int]$size_scaler_trackbar.AccessibleName - [int]$distance
                #write-host D4 $distance - $script:settings['width'] x $script:settings['height']
                $output_height_box.text = $script:settings['height']
                $output_width_box.text = $script:settings['width']
            }
         }  
    })
    $Form.Controls.add($size_scaler_trackbar)


    #################################################################################  
    ###########Merge To Frames Submit Button
    $y_pos = $y_pos + 45
    $merge_frames_to_video_submit_button = New-Object System.Windows.Forms.Button
    $merge_frames_to_video_submit_button.Location= New-Object System.Drawing.Size((($Form.width / 2) - 100),($y_pos))
    $merge_frames_to_video_submit_button.anchor = "Top"
    $merge_frames_to_video_submit_button.BackColor = "#606060"
    $merge_frames_to_video_submit_button.ForeColor = "White"
    $merge_frames_to_video_submit_button.Width=200
    $merge_frames_to_video_submit_button.Height=25
    $merge_frames_to_video_submit_button.Text='Frames-to-Video'
    $merge_frames_to_video_submit_button.Add_Click({
        $continue = 1;
        if(Test-Path -LiteralPath $script:settings['output_video'])
        {
            $message = "The output video name you have selected already exists. If you continue it will be overwritten.`n`nContinue?`n`n"
            $yesno = [System.Windows.Forms.MessageBox]::Show("$message","WARNING!!!", "YesNo" , "Information" , "Button1")
            if($yesno -eq "No")
            {
                $continue = 0;
            }
        }
        if($continue -eq 1)
        {
            $message = "PNG files in the Frames Input Directory will be automatically renamed numerically for FFmpeg sequence video generation. This will maintain your current frame sequence, however files will be renamed to a simple 4 digit numeric reference.  `n`nContinue?`n`n"
            $yesno = [System.Windows.Forms.MessageBox]::Show("$message","WARNING!!!", "YesNo" , "Information" , "Button1")
            if($yesno -eq "No")
            {
                $continue = 0;
            }
        }
        if($continue -eq 1)
        {
            merge_to_video $script:settings['output_video'] $script:settings['input_frames_dir'] $script:settings['width'] $script:settings['height'] $script:settings['merge_fps'] $script:settings['input_audio']
            $message = "Video Generation Finished!"
            [System.Windows.MessageBox]::Show($message,"Finished!",'Ok')
            Start-Process $script:settings['output_video']
        }
    })
    $Form.controls.Add($merge_frames_to_video_submit_button)

    update_settings
    $Form.ShowDialog()
}
################################################################################
######Rip to Frames#############################################################
function rip_to_frames($video,$output_dir,$fps)
{
    #Clean Directory
    $output_dir_contents = Get-ChildItem -LiteralPath $output_dir
    foreach($item in $output_dir_contents)
    {
        if($item.Extension -match "png")
        {
            Remove-Item -LiteralPath $item.FullName
        }
    }


    write-host "Frame Source:     " $video
    write-host "Output Directory: " $output_dir
    write-host "FFmpeg:           " $script:settings['ffmpeg']

    $execute = $script:settings['ffmpeg'] + " -i `"$video`" -vf fps=$fps `"$output_dir\%04d.png`" -hide_banner"
    write-host "Executed:         " $execute
    $console = & cmd /u /c  $execute
    
}
################################################################################
######Merge Frames To Video#####################################################
function merge_to_video($video_name,$input_frames,$width,$height,$fps,$audio)
{
    write-host "Save Name:  " $video_name
    write-host "Frame Rate: " $input_frames
    write-host "Width:      " $width
    write-host "Height:     " $height
    write-host "FFmpeg:     " $script:settings['ffmpeg']
    write-host "Audio:      " $audio
    write-host "FPS:        " $fps
    $buffer = "$dir\Required\buffer.mp4"
    if(Test-Path -LiteralPath $buffer)
    {
        Remove-Item -LiteralPath $buffer
    }
    if(Test-Path -LiteralPath $video_name)
    {
        Remove-Item -LiteralPath $video_name
    }
    ################################################################################
    ######Rename PNG Files##########################################################
    $frame_dir = Get-ChildItem -LiteralPath $input_frames -Include *.png
    $counter = 0;
    foreach($png in $frame_dir)
    {
        $counter++;
        $number = $counter;
        [string]$number = ([string]$number).padleft(4,"0")
        [string]$new_name = Split-Path($png.fullname)
        $new_name = $new_name + "\$number.png"
        Rename-Item -LiteralPath $png.fullname $new_name
    }

    ################################################################################
    ######Execute Dual Action Video & Audio ########################################
    if(($audio -ne "") -and ($audio -ne $null) -and (Test-Path -LiteralPath $audio))
    {
        ############First pass Frames-to-Video
        [string]$execute = [string]$script:settings['ffmpeg'] + " -framerate $fps -pattern_type sequence -start_number 0001 -i `"$input_frames\%04d.png`" -vf scale=$width" + ":" +"$height -hide_banner -c:v libx264 -pix_fmt yuv420p `"$buffer`" -y"
        write-host "Executed:   " $execute
        $console = & cmd /u /c $execute

        ############Second pass Audio-to-Video
        [string]$execute = [string]$script:settings['ffmpeg'] + " -i `"$buffer`" -i `"$audio`" -hide_banner -c copy -map 0:v -map 1:a -shortest `"$video_name`" -y"
        write-host "Executed:   " $execute
        $console = & cmd /u /c $execute
    }
    ################################################################################
    ######Execute Single Action Video Only##########################################
    else
    {
        ############One Pass Frames-to-Video
        [string]$execute = [string]$script:settings['ffmpeg'] + " -framerate $fps -pattern_type sequence -start_number 0001 -i `"$input_frames\%04d.png`" -vf scale=$width" + ":" +"$height -hide_banner -c:v libx264 -pix_fmt yuv420p `"$video_name`"  -y "
        write-host "Executed:   " $execute
        $console = & cmd /u /c $execute
    }
}
################################################################################
######Prompt for File###########################################################
function prompt_for_file()
{  
 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
 #$OpenFileDialog.filter = "All files (*.*)| *.*"
 $OpenFileDialog.filter = "Video Files (*.mp4, *.mkv)|*.mp4;*.mkv;"
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
}
################################################################################
######Prompt for File###########################################################
function prompt_for_audio()
{  
 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
 #$OpenFileDialog.filter = "All files (*.*)| *.*"
 $OpenFileDialog.filter = "Audio Files (*.mp4, *.mkv, *.mp3)|*.mp4;*.mkv;*.mp3"
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
}
################################################################################
######Prompt for File Exe###########################################################
function prompt_for_file_exe()
{  
 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
 #$OpenFileDialog.filter = "All files (*.*)| *.*"
 $OpenFileDialog.filter = "FFMpeg (*.exe)|*.exe;"
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
}
################################################################################
######Prompt for Folder#########################################################
function prompt_for_folder()
{  
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $folder_dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folder_dialog.Description = "Select Target folder"
    $folder_dialog.rootfolder = "MyComputer"

    if($folder_dialog.ShowDialog() -eq "OK")
    {
        $folder = $folder_dialog.SelectedPath
    }
    return $folder
}
################################################################################
#####Delete Folder or File######################################################
function delete_folder_or_file($target)
{
    #write-host $target
    if(Test-Path -LiteralPath $target)
    {
        if((Get-Item -literalpath $target) -is [System.IO.DirectoryInfo])
        {
            #write-host Deleting Folder
            $Items = Get-ChildItem -LiteralPath "$target" -Recurse
            foreach ($Item in $Items) 
            {
                $Item.Delete()
            }
            $Items = Get-Item -LiteralPath "$target"
            $Items.Delete($true)
        }
        else
        {
            #write-host Deleting File
            $Item = Get-Item -LiteralPath "$target"
            $Item.Delete()
        }
    } 
}
################################################################################
####CSV to Line Array###########################################################
function csv_line_to_array ($line)
{
    if($line.Substring(0,1) -eq ",")
    {
        $line = ",$line"; 
    }
    Select-String '(?:^|,)(?=[^"]|(")?)"?((?(1)[^"]*|[^,"]*))"?(?=,|$)' -input $line -AllMatches | Foreach { $line_split = $_.matches -replace '^,|"',''}
    [System.Collections.ArrayList]$line_split = $line_split
    return $line_split
}
################################################################################
######Initial Checks############################################################
function initial_checks
{
    if(!(Test-Path -LiteralPath "$dir\Required"))
    {
        New-Item  -ItemType directory -Path "$dir\Required"
    }
}
#################################################################################
######Load Settings##############################################################
function load_settings
{
    if(Test-Path -literalpath "$dir\Required\Settings.csv")
    {
        $line_count = 0;
        $reader = [System.IO.File]::OpenText("$dir\Required\Settings.csv")
        while($null -ne ($line = $reader.ReadLine()))
        {
            $line_count++;
            if($line_count -ne 1)
            {
                ($key,$value) = csv_line_to_array $line
                if(!($script:settings.containskey($key)))
                {
                    $script:settings.Add($key,$value);
                }
            } 
        }
        $reader.close();
    }
}
################################################################################
#####Update Settings############################################################
function update_settings
{
    if($script:settings.count -ne 0)
    {
        if(Test-Path "$dir\Required\Buffer_Settings.csv")
        {
            delete_folder_or_file "$dir\Required\Buffer_Settings.csv"
        }
        $buffer_settings = new-object system.IO.StreamWriter("$dir\Required\Buffer_Settings.csv",$true)
        $buffer_settings.write("PROPERTY,VALUE`r`n");
        foreach($setting in $script:settings.getEnumerator() | Sort key)                  #Loop through Input Entries
        {
                $setting_key = $setting.Key                                               
                $setting_value = $setting.Value
                $buffer_settings.write("$setting_key,$setting_value`r`n");
        }
        $buffer_settings.close();
        if(test-path -LiteralPath "$dir\Required\Buffer_Settings.csv")
        {
            if(Test-Path -LiteralPath "$dir\Required\Settings.csv")
            {
                #Remove-Item -LiteralPath "$dir\Required\Settings.csv"
                delete_folder_or_file "$dir\Required\Settings.csv"
            }
            Rename-Item -LiteralPath "$dir\Required\Buffer_Settings.csv" "$dir\Required\Settings.csv"
        }
    }
    interface_update
}
################################################################################
#####Interface Update###########################################################
function interface_update
{
    if(($input_video_label.ForeColor -eq "Green") -and ($output_frames_dir_label.ForeColor -eq "Green") -and ($ffmpeg_location_label1.ForeColor -eq "Green"))
    {
        $rip_fps_label1.ForeColor = "Green"
        $rip_fps_status1.ForeColor = "Green"
        $rip_to_frames_submit_button.Enabled = $true
    }
    else
    {
        $rip_fps_label1.ForeColor = "White"
        $rip_fps_status1.ForeColor = "White"
        $rip_to_frames_submit_button.Enabled = $false
    }


    #######################################################
    #######################################################
    if(($input_frames_label.ForeColor -eq "Green") -and ($output_video_label.ForeColor -eq "Green") -and ($ffmpeg_location_label2.ForeColor -eq "Green"))
    {
        $size_scale_label.ForeColor = "Green"
        $merge_fps_label2.ForeColor = "Green"
        $size_x_label.ForeColor = "Green"
        $output_dim_label.ForeColor = "Green"
        $merge_fps_status2.ForeColor = "Green"
        if(!($input_audio_label.ForeColor -eq "Green"))
        {
            $input_audio_label.ForeColor = "darkGreen"
        }
        $merge_frames_to_video_submit_button.enabled = $true
    }
    else
    {
        $size_scale_label.ForeColor = "White"
        $merge_fps_label2.ForeColor = "White"
        $size_x_label.ForeColor = "White"
        $output_dim_label.ForeColor = "White"
        $merge_fps_status2.ForeColor = "White"
        if(!($input_audio_label.ForeColor -eq "Green"))
        {
            $input_audio_label.ForeColor = "White"
        }
        $merge_frames_to_video_submit_button.enabled = $false
    }
}
################################################################################
######Main Sequence Start#######################################################
initial_checks
load_settings
main
################################################################################
#####Change Log#################################################################
#
#1 Aug 2023
#Public Release of Ver 1.0
#