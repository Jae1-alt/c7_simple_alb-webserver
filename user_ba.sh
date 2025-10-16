#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Get the IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Background the curl requests
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4 &> /tmp/local_ipv4 &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone &> /tmp/az &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/ &> /tmp/macid &
wait

macid=$(cat /tmp/macid)
local_ipv4=$(cat /tmp/local_ipv4)
az=$(cat /tmp/az)
vpc=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${macid}/vpc-id)
HOST_NAME=$(hostname -f)

# The shell will replace the variables like $local_ipv4 with the values we got from curl.
# Using a "heredoc" (here document) - a cleaner way to write multi-line text
# "cat << EOF" means "output everything until you see 'EOF' on its own line"
# This is easier to read than using echo with quotes, especially for HTML
# '/var/www/html/index.html' is the location of the html script on the new server
cat <<EOF > /var/www/html/index.html
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>1st EC2 instance</title>
    <link rel="stylesheet" href="style.css?v=2.13.A">
</head>
<body>
    <div class="header-shape">
        <h1>AWS Instance 1 Details</h1>
        <h2>All done in Terraform with Blood, Sweat and Tears.</h2>
        <p>I, Jaune Alcide, thank Suge WAF and My Senpais, For Teaching Me about the Cloud. One Step Closer To Escaping Keisha!</p>
        <p><strong>With This Class, I Will Net >\$500,000 Per Year!</strong></p>
    </div>

    <div class="hexagon-gallery">
        <div class="hex-row">
            <div class="hexagon-item" data-src="https://images.ctfassets.net/jvp71l3ed0ev/kSuB5bMCnShXjjRLfW4qt/31ff4ac3bbfc332c7cd256122a13863b/ATMK_10_0042.JPG">
                <div class="hexagon">
                    <img src="https://images.ctfassets.net/jvp71l3ed0ev/kSuB5bMCnShXjjRLfW4qt/31ff4ac3bbfc332c7cd256122a13863b/ATMK_10_0042.JPG" alt="Lush green forest">
                    <div class="hex-text"><span>View from Future Home</span></div>
                </div>
            </div>
            <div class="hexagon-item" data-src="https://images.ctfassets.net/jvp71l3ed0ev/1zIqtlcv5FBCYaJzACZpLV/0a9ffc0479ce289edb6151f8694754de/04.JPG">
                <div class="hexagon">
                    <img src="https://images.ctfassets.net/jvp71l3ed0ev/1zIqtlcv5FBCYaJzACZpLV/0a9ffc0479ce289edb6151f8694754de/04.JPG" alt="River in a mountain valley">
                    <div class="hex-text"><span>Future Home Bath</span></div>
                </div>
            </div>
        </div>
        <div class="hex-row">
            <div class="hexagon-item" data-src="https://i.pinimg.com/originals/c6/24/54/c62454d7ec5cdb0f8484c207dd7a69b0.jpg">
                <div class="hexagon">
                    <img src="https://i.pinimg.com/originals/c6/24/54/c62454d7ec5cdb0f8484c207dd7a69b0.jpg" alt="Misty forest path">
                    <div class="hex-text"><span>....</span></div>
                </div>
            </div>
            <div class="hexagon-item" data-src="https://image.made-in-china.com/365f3j00OlrtdIWMfNbp/New-Stylish-Mature-Women-Blue-Ruffled-Sexy-Brazilian-Triangle-Strappy-Bikini.webp">
                <div class="hexagon">
                    <img src="https://image.made-in-china.com/365f3j00OlrtdIWMfNbp/New-Stylish-Mature-Women-Blue-Ruffled-Sexy-Brazilian-Triangle-Strappy-Bikini.webp" alt="Sun setting over a grassy field">
                    <div class="hex-text"><span>Bronze Bomb</span></div>
                </div>
            </div>
            <div class="hexagon-item" data-src="https://tlceventsandweddings.com/wp-content/uploads/2021/08/Sexy-Thai-Bride.jpg">
                <div class="hexagon">
                    <img src="https://tlceventsandweddings.com/wp-content/uploads/2021/08/Sexy-Thai-Bride.jpg" alt="Sun rays through a large tree">
                    <div class="hex-text"><span>That Look</span></div>
                </div>
            </div>
        </div>
    </div>

    <div class="details-box">
        <div class="instance-info">
            <p><b>Instance Name:</b> ${HOST_NAME}</p>
            <p><b>Instance Private Ip Address: </b> ${local_ipv4}</p>
            <p><b>Availability Zone: </b> ${az}</p>
            <p><b>Virtual Private Cloud (VPC):</b> ${vpc}</p>
        </div>

        <div class="button-container">
            <a href="https://scontent.fmbj2-2.fna.fbcdn.net/v/t39.30808-6/480791260_1616688689015102_2464800278410713211_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=a5f93a&_nc_ohc=8xiryEOrWIYQ7kNvwGh4e2q&_nc_oc=Adl2SRMkxkNhlUxTRQRzgTZlh1nlijFJfzyr-Frh1R1DA3a9AUrhBFO7TreRLQgieNY&_nc_zt=23&_nc_ht=scontent.fmbj2-2.fna&_nc_gid=t2ScWN2AEB0GzTP9SW5T7A&oh=00_Afc_FaWCn1DrBHFaNZf2ct4M9S54CjjEez3HAjb4wVVJ4A&oe=68E503EC" target="_blank" class="repo-button">
                Don't want to read? Great, have this!
            </a>
            <a href="https://github.com/Jae1-alt/c7_250915_simple_ec2.git" target="_blank" class="repo-button">
                This project's GitHub Repo.
            </a>
        </div>
    </div>

    <div id="imageModal" class="modal">
        <span class="close-button">&times;</span>
        <img class="modal-content" id="modalImage">
    </div>

    <script>
        // Get the elements we need to work with
        const modal = document.getElementById('imageModal');
        const modalImg = document.getElementById('modalImage');
        const closeBtn = document.querySelector('.close-button');
        const hexagonItems = document.querySelectorAll('.hexagon-item');

        // Loop through all hexagons and add a click event to each
        hexagonItems.forEach(item => {
            item.addEventListener('click', () => {
                modal.style.display = 'flex'; // Show the modal (using flex to center content)
                modalImg.src = item.dataset.src; // Set the image source from the data-src attribute
            });
        });

        // Function to close the modal
        function closeModal() {
            modal.style.display = 'none';
        }

        // Add click events to close the modal
        closeBtn.addEventListener('click', closeModal);
        modal.addEventListener('click', (e) => {
            // Close the modal if the user clicks on the dark overlay (but not the image itself)
            if (e.target === modal) {
                closeModal();
            }
        });
    </script>
</body>
</html>
EOF

#Create the CSS file using another Heredoc
cat <<EOF > /var/www/html/style.css
body {
  font-family: sans-serif;
  background-image: url('https://www.trafalgar.com/real-word/wp-content/uploads/sites/3/2018/01/Arashiyama-Bamboo-Forest-Japan-www.istockphoto.com_gb_photo_arashiyama-bamboo-forest-in-kyoto-japan-gm598073336-102483809-FilippoBacci.jpg');
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center center;
  background-attachment: fixed;
  color: white;
  margin: 0;
  padding: 2vh 20px;
  box-sizing: border-box;
  text-align: center;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

/* --- Header Shape --- */
.header-shape {
    padding: 40px 60px;
    margin: 0 auto 40px auto;
    width: 98%;
    max-width: 1400px;
    background-color: rgba(40, 40, 40, 0.8);
    color: white;
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.5);
    /* CHANGED: Border color is now green */
    border: 3px solid #28a745;
    border-radius: 60px 60px 15px 15px;
    box-sizing: border-box;
}

h1, h2 {
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);
}

/* --- Hexagon Gallery --- */
.hexagon-gallery {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  margin-bottom: 40px;
  gap: 5px;
}
.hex-row {
  display: flex;
  justify-content: center;
  gap: 20px;
}
.hex-row:nth-child(2) { margin-top: -52px; }
.hexagon-item {
  display: block;
  cursor: pointer;
  /* CHANGED: Swapped the white glow for the green border color */
  filter: drop-shadow(0 0 10px rgba(40, 167, 69, 0.5));
  transition: filter 0.3s ease;
}
.hexagon {
  position: relative;
  width: 180px;
  height: 208px;
  background-color: #333;
  overflow: hidden;
  clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
  transition: transform 0.3s ease-in-out;
}
.hexagon img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: filter 0.3s ease;
}
.hex-text {
  position: absolute;
  top: 0; left: 0;
  width: 100%; height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: rgba(0, 0, 0, 0.6);
  color: white;
  font-weight: normal;
  font-size: 1.1em;
  padding: 10px;
  text-align: center;
  opacity: 0;
  transition: opacity 0.3s ease;
}
.hexagon-item:hover .hex-text { opacity: 1; }
.hexagon-item:hover .hexagon img { filter: brightness(0.6); }
.hexagon-item:hover .hexagon { transform: scale(1.1); }
.hexagon-item:hover {
    /* CHANGED: Made the hover glow a stronger version of the green border color */
    filter: drop-shadow(0 0 15px rgba(40, 167, 69, 0.8));
}

/* --- Bottom Details Box --- */
.details-box {
    width: 98%;
    max-width: 1400px;
    margin: 40px auto 20px auto;
    padding: 25px;
    background-color: rgba(40, 40, 40, 0.8);
    color: white;
    /* CHANGED: Border color is now green */
    border: 3px solid #28a745;
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
}
.instance-info {
  display: grid;
  grid-template-columns: 1fr 1fr;
  grid-template-rows: auto auto;
  gap: 15px 25px;
  margin-bottom: 30px;
  text-align: left;
  max-width: 800px;
  margin-left: auto;
  margin-right: auto;
}
.button-container {
    margin-top: 20px;
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 20px;
}

/* CHANGED: Button theme is now white and green */
.repo-button {
  display: inline-block;
  padding: 15px 30px;
  font-size: 1.1em;
  background-image: linear-gradient(45deg, #ffffff 0%, #d4edda 100%);
  color: #155724; /* Dark green text for contrast */
  text-decoration: none;
  font-weight: bold;
  border-radius: 50px;
  border: 2px solid #155724; /* Solid dark green border */
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
  text-shadow: none;
  transition: all 0.3s ease;
}
.repo-button:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4); /* Green shadow on hover */
}

/* CORRECTED: CSS for the image modal */
.modal {
  display: none;
  position: fixed;
  z-index: 1000;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.85);
  align-items: center;
  justify-content: center;
}

.modal-content {
  margin: auto;
  display: block;
  max-width: 85%;
  max-height: 85%;
  border-radius: 5px;
}

.close-button {
  position: absolute;
  top: 20px;
  right: 35px;
  color: #f1f1f1;
  font-size: 40px;
  font-weight: bold;
  transition: 0.3s;
  cursor: pointer;
}

.close-button:hover,
.close-button:focus {
  color: #bbb;
  text-decoration: none;
}
EOF

# Clean up the temp files
rm -f /tmp/local_ipv4 /tmp/az /tmp/macid