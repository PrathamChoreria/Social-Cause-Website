const express=require("express")
const ejs=require("ejs")
const app=express()
const mysql=require("mysql")
const bodyParser = require("body-parser");
const session=require("express-session")



app.set("view engine","ejs");
app.use(bodyParser.urlencoded({extended:true}));
app.use(session({secret:"secret",resave: true,
saveUninitialized: true}))


app.get("/",(req,res)=>{
    res.render("pages/home")
})
app.get("/children",(req,res)=>{
    res.render("pages/child")
})

app.post("/register_child",(req,res)=>{
    var adhaar=req.body.adhaar;
    var name=req.body.name;
    var age=req.body.age;
    var income=req.body.income;
    var city=req.body.city;
    var caste=req.body.caste;
    var needs=req.body.needs;
    var gender=req.body.gender;

    var con =mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "",
        port:3307,
        database:"hope1"
      })


    con.connect((err)=>{
        if(err){
            res.send("Error please enter different name or emailid");
            console.log({"err":err});
        }

            console.log("connected");
            console.log(caste);
            console.log(income);

        if(income<20000){
            if(caste.toLowerCase()==="obc"||caste.toLowerCase()==="sc"){
            var query="INSERT INTO children(Name,Age,Annual_Income,caste,city,gender,needs,Adhaar_Number) VALUES(?,?,?,?,?,?,?,?)";
            con.query(query,[name,age,income,caste,city,gender,needs,adhaar],(err,result)=>{
                if(!err){
                    res.send("inserted");
                }else{
                    console.log(err)
                }
            })

        }else{
            res.send({result:"caste not eligible"})
        }}
        else{
            res.send({result:"annual_income is not eligible"})
        }

        
    })  

})

app.post("/register_educator",(req,res)=>{

    var adhaar=req.body.adhaar;
    var name=req.body.name;
    var age=req.body.age;
    var gender=req.body.gender;
    var centre=""
    var subject=req.body.subject;


    var con =mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "",
        port:3307,
        database:"hope1"
      })


    con.connect((err)=>{
        if(err){
            res.send("Error please enter different name or emailid");
            console.log({err:err});
        }
        else{
            var g=gender.toLowerCase();
            console.log(g);
            if(gender.toLowerCase()=="male"){
                centre="C1";
            }
            else{
                centre="C2";
            }
            var query="INSERT INTO educator(Adhaar_Number,name,age,gender,centre,subject) VALUES ?";
            var values=[
                [adhaar,name,age,gender,centre,subject]
            ];
            console.log(values);
            con.query(query,[values],(err,result)=>{
                if(!err){
                res.send("inserted");}
                else{
                    console.log(err)
                }
            })
        }
})
})


app.post("/charity_funds",(req,res)=>{
    var organisation_name=req.body.organisation_name;
    var email=req.body.email;
    var amount=req.body.amount;

    
    var con =mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "",
        port:3307,
        database:"hope1"
      })


    con.connect((err)=>{
        if(err){
            res.send("Error occurred");
            console.log({err:err});
        }else{
            var query="INSERT INTO charity(organisation_name,email,amount) VALUES ?";
            var values=[[organisation_name,email,amount]];
            con.query(query,[values],(err,result)=>{
                if(!err){
                res.send("inserted into charity");}
                else{
                    res.send(err);
                }
            })
            con.end();
        }



})

})


app.post("/donation",(req,res)=>{

    var adhaar_number=req.body.adhaar;
    var name=req.body.name;
    var donate=req.body.donate;
    var gender=req.body.gender;



    var con =mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "",
        port:3307,
        database:"hope1"
      })


    con.connect((err)=>{
        if(err){
            res.send("Error occurred");
            console.log({err:err});
        }
        else{
            var query="INSERT INTO donar(Adhaar_Number,name,donating,gender) VALUES ?";
            var values=[[adhaar_number,name,donate,gender]];

            con.query(query,[values],(err,result)=>{
                if(!err){
                    res.send("donor added for needs");
                    console.log(values);
                }
                else{
                    res.send(err);
                }
            })

        }
})

})

app.get("/wow",(req,res)=>{
    res.render("pages/connect1");})


app.post("/connect",(req,res)=>{
    var adhaar=req.body.adhaar;
    
    var con =mysql.createConnection({
       
        host: "localhost",
        user: "root",
        password: "",
        port:3307,
        database:"hope1",
        multipleStatements: true
      })


    con.connect((err)=>{
        if(err){
            res.send("Error occurred");
            console.log({err:err});
        }
        else{
             var query="SELECT needs from children where Adhaar_Number=?";
             var value=[adhaar];
             con.query(query,[value],(err,result)=>{
                console.log(result[0]);
                var string=JSON.stringify(result);
                console.log(string);
                var json=JSON.parse(string);
                console.log(json)
                console.log(json[0].needs);
                var needs=json[0].needs;
                query1="SELECT * from donar where donating=? LIMIT 1";
                con.query(query1,[needs],(err,result1)=>{
                    if(!err){    
                    console.log(result1);
                    res.render("pages/connect",{result1:result1,needs:needs,child_adh:req.session.adhaar});
                    }
                    else{
                        console.log(err);
                    }
                })
             })
        }
    })

   req.session.adhaar=adhaar;
   //req.session.needs=needs;
   

})

app.post("/approve",(req,res)=>{
    var donation_id=req.body.donation_id;
    var needs=req.body.needs;
    var child_adhaar=req.body.child_adhaar;
    var con =mysql.createConnection({
       
        host: "localhost",
        user: "root",
        password: "",
        port:3307,
        database:"hope1",
        multipleStatements: true
      })


    con.connect((err)=>{
        if(err){
            res.send("Error occurred");
            console.log({err:err});
        }
        else{
            var query="DELETE FROM donar where Donation_id=?";
            var values=[donation_id];
            con.query(query,[values],(err,result)=>{
                if(!err){
                    console.log("atleast deleted");
                    var query1="UPDATE children set needs='' where Adhaar_Number=?"
                    var value1=[child_adhaar];
                    con.query(query1,[value1],(err,result1)=>{
                        console.log(result1);
                        res.send("success")
                    })
                    console.log(result);
                    }
                    else{
                        console.log(err)
                    }
                })
                }
            })

            req.session.needs=null;
            req.session.adhaar=null;

        }

)



app.listen(3000,()=>{
    console.log("listening")

})