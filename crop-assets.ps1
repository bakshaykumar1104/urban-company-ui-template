Add-Type -AssemblyName System.Drawing

$projectRoot = Split-Path -Parent $PSScriptRoot
$sourceRoot = Split-Path -Parent $projectRoot
$outputRoot = Join-Path $projectRoot 'dist\assets'

$crops = @(
    @{ Source='LS_2026-11-17_10-22-14.png'; Output='home-banner.jpg'; X=0; Y=220; W=1080; H=620 },
    @{ Source='LS_2026-11-17_10-23-30.png'; Output='salon-women.jpg'; X=0; Y=110; W=1080; H=620 },
    @{ Source='LS_2026-11-17_10-24-15.png'; Output='spa-women.jpg'; X=0; Y=110; W=1080; H=590 },
    @{ Source='LS_2026-11-17_10-25-25.png'; Output='salon-men.jpg'; X=0; Y=110; W=1080; H=590 },
    @{ Source='LS_2026-11-17_10-26-05.png'; Output='massage-men.jpg'; X=0; Y=110; W=1080; H=590 },
    @{ Source='LS_2026-11-17_10-28-51.png'; Output='bathroom-cleaning.jpg'; X=0; Y=120; W=1080; H=650 },
    @{ Source='LS_2026-11-17_10-29-20.png'; Output='home-cleaning.jpg'; X=0; Y=520; W=1080; H=620 },
    @{ Source='LS_2026-11-17_10-29-49.png'; Output='sofa-cleaning.jpg'; X=0; Y=110; W=1080; H=620 },
    @{ Source='LS_2026-11-17_10-30-28.png'; Output='painting.jpg'; X=0; Y=100; W=1080; H=610 },
    @{ Source='LS_2026-11-17_10-32-09.png'; Output='ac-repair.jpg'; X=0; Y=100; W=1080; H=610 },
    @{ Source='LS_2026-11-17_10-32-49.png'; Output='refrigerator.jpg'; X=0; Y=70; W=1080; H=650 },
    @{ Source='LS_2026-11-17_10-35-45.png'; Output='water-purifier.jpg'; X=0; Y=650; W=1080; H=690 },
    @{ Source='LS_2026-11-17_10-37-31.png'; Output='electrician.jpg'; X=0; Y=500; W=1080; H=610 },
    @{ Source='LS_2026-11-17_10-38-01.png'; Output='plumber.jpg'; X=0; Y=500; W=1080; H=610 },
    @{ Source='LS_2026-11-17_10-38-51.png'; Output='carpenter.jpg'; X=0; Y=500; W=1080; H=610 },
    @{ Source='LS_2026-11-17_10-49-37.png'; Output='referral.jpg'; X=0; Y=0; W=1080; H=900 }
)

foreach ($crop in $crops) {
    $sourcePath = Join-Path $sourceRoot $crop.Source
    $outputPath = Join-Path $outputRoot $crop.Output
    if (-not (Test-Path -LiteralPath $sourcePath)) { continue }

    $source = [System.Drawing.Image]::FromFile($sourcePath)
    try {
        $x = [Math]::Min($crop.X, $source.Width - 1)
        $y = [Math]::Min($crop.Y, $source.Height - 1)
        $width = [Math]::Min($crop.W, $source.Width - $x)
        $height = [Math]::Min($crop.H, $source.Height - $y)
        $bitmap = New-Object System.Drawing.Bitmap $width, $height
        try {
            $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
            try {
                $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $graphics.DrawImage($source, 0, 0, [System.Drawing.Rectangle]::new($x, $y, $width, $height), [System.Drawing.GraphicsUnit]::Pixel)
            } finally { $graphics.Dispose() }
            $bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
        } finally { $bitmap.Dispose() }
    } finally { $source.Dispose() }
}

Get-ChildItem -LiteralPath $outputRoot -File | Select-Object Name, Length
