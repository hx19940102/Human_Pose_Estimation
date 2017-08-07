# Pose-Estimation
Human Pose estimation based on Energy Minimization

Firstly we should build a model for human pose, it mainly consists of left arm, right arm, head and torso. There exist joints between different parts of the human pose.

![alt text](https://github.com/hx19940102/Pose-Estimation/blob/master/images/structure.png)

An instance of a part in an image is specified by a location 𝑙 which specifies the position, rotation and scale parameters. The match cost function 𝑚𝑖(𝐼,𝑙) measures how well the part matches the image 𝐼 when placed at location 𝑙. The connections between parts indicate relationships between their locations. For each connection (𝑣𝑖,𝑣𝑗) there is a deformation cost function 𝑑𝑖𝑗=(𝑙𝑖,𝑙𝑗) measuring how well the locations 𝑙𝑖 of 𝑣𝑖 and 𝑙𝑗 of 𝑣𝑗 agree with the object model.

A configuration 𝐿=(𝑙1,…,𝑙𝑛) specifies the location for each of the parts, 𝑣𝑖 𝜖 𝑉 with respect to the image. The problem of estimating the pose can be formulated as finding the optimal location 𝐿∗, that minimizes the deformation and match cost as, 𝐿∗=argmin𝐿(Σ𝑑𝑖𝑗(𝑙𝑖,𝑙𝑗)+Σ𝑚𝑖(𝐼,𝑙𝑖)𝑣𝑖𝜖𝑉(𝑣𝑖,𝑣𝑗)𝜖𝐸)

We have chosen Torso as the ‘root node’ of the tree-structured model. To find the optimal location of the Torso, we first discretize the space of all possible part locations into 50 buckets for each x and y positions, 10 buckets for size, and 20 buckets for orientation. Using the match_energy_cost function we choose five best possible locations having the least cost. The quality of the best location of a vertex 𝑣𝑗 given the location 𝑙𝑖 of 𝑣𝑖 is, 𝐵𝑗(𝑙𝑖)=min𝑙𝑗(𝑑𝑖𝑗(𝑙𝑖,𝑙𝑗)+𝑚𝑗(𝐼,𝑙𝑗))

Given the optimal locations of the root node, we then find the optimal locations of the leaf nodes that minimize 𝐵𝑗(𝑙𝑖).
We first find the optimal location of the torso followed by the optimal locations of the head, upper left and right arms. Since the lower arms are connected to the upper arms, we find their optimal locations based on the optimal locations of the upper arms.

Given the observed locations 𝑙𝑖=(𝑥𝑖,𝑦𝑖,𝜃𝑖,𝑠𝑖) and 𝑙𝑗=(𝑥𝑗,𝑦𝑗,𝜃𝑗,𝑠𝑗) of two parts, the deformation cost measures the deviation between the ideal values and the observed values. The deformation_cost function takes 𝑙𝑖 and 𝑙𝑗 as the input parameters and returns the deformation cost between the two locations. We define the pairwise deformation cost for the person model to be, 𝑑𝑖𝑗(𝑙𝑖,𝑙𝑗)=𝑤𝜃∗|𝜃𝑖−𝜃𝑗|+𝑤𝑠∗|𝑠𝑖−𝑠𝑗|+𝑤𝑥∗|𝑥𝑖−𝑥𝑗|+𝑤𝑦∗|𝑦𝑖−𝑦𝑗|
Where the first term is the difference between the ideal relative angle and the observed relative angle, the second term is the difference between the ideal relative size and the observed relative size. The ideal relative angle, 𝜃𝑖 and the ideal relative size 𝑠𝑖𝑗 are set to 0 and 1 respectively. The third and fourth terms are the horizontal and vertical distances between the observed joint positions.

The weights denote the contribution of the corresponding terms in the deformation cost. We set the value of 𝑤𝜃 to be 0.1, to emphasize the fact that parts can rotate freely about the joint. The values of the remaining weights are set to 5. Next, we convert the coordinates of joint points from the parts’ coordinate system to the image coordinate system as, (𝑥𝑖′,𝑦𝑖′)𝑇=𝑊𝑖𝑗((𝑥𝑖,𝑦𝑖)𝑇+𝑠𝑖𝑅𝜃𝑖(𝑥𝑖𝑗,𝑦𝑖𝑗)𝑇
Where 𝑊𝑖𝑗 is a diagonal weight matrix with entries 𝑤𝑖𝑗𝑥 and 𝑤𝑖𝑗𝑦 , and 𝑅𝜃𝑖 is a matrix that performs rotation of 𝜃 radians about the origin.

The estimation results is quite accurate and the time cost by the program is about 50 seconds.
![alt text](https://github.com/hx19940102/Pose-Estimation/blob/master/images/000089.png)
![alt text](https://github.com/hx19940102/Pose-Estimation/blob/master/images/0001425.png)
![alt text](https://github.com/hx19940102/Pose-Estimation/blob/master/images/001113.png)
![alt text](https://github.com/hx19940102/Pose-Estimation/blob/master/images/001143.png)
![alt text](https://github.com/hx19940102/Pose-Estimation/blob/master/images/001305.png)
![alt text](https://github.com/hx19940102/Pose-Estimation/blob/master/images/002108.png)
![alt text](https://github.com/hx19940102/Pose-Estimation/blob/master/images/006220.png)
![alt text](https://github.com/hx19940102/Pose-Estimation/blob/master/images/008671.png)
![alt text](https://github.com/hx19940102/Pose-Estimation/blob/master/images/052750.png)
