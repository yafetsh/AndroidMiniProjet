/*
RESTFUL Services by NodeJS
Author: Yafet Shil
*/
var crypto = require('crypto');
var uuid = require ('uuid');
var express = require('express');
var mysql = require('mysql');
var bodyParser = require('body-parser');

//Connect to MySQL
var con = mysql.createConnection({
    host:'127.0.0.1',
    port: '8889',
    user: 'root',
    password: 'root',
    connector: 'mysql',
    database: 'miniprojet',
    socketPath: '/Applications/MAMP/tmp/mysql/mysql.sock'
});
con.connect((err)=> {
    if(!err)
        console.log('Connection Established Successfully');
    else
        console.log('Connection Failed!'+ JSON.stringify(err,undefined,2));
});

//PASSWORD CRYPT
var genRandomString = function (length) {
    return crypto.randomBytes(Math.ceil(length/2))
        .toString('hex') //Convert to hexa format
        .slice(0,length);
    
};
var sha512 = function (password,salt) {
    var hash = crypto.createHmac('sha512',salt) ; //Use SHA512
    hash.update(password);
    var value = hash.digest('hex');
    return {
        salt:salt,
        passwordHash:value
    };
    
};
/* Hash password */
function saltHashPassword(userPassword) {
    var salt = genRandomString(16); //Gen Random string with 16 charachters
    var passwordData = sha512(userPassword,salt) ;
    return passwordData;
    
}
function checkHashPassword(userPassword,salt) {
    var passwordData = sha512(userPassword,salt);
    return passwordData;
    
}

var app = express();
app.use(bodyParser.json()); // Accept JSON params
app.use(bodyParser.urlencoded({extended:true})); //Accept UrlEncoded params

/* REGISTER */
app.post('/register/',(req,res,next)=>{
    var post_data = req.body;  //Get POST params
    var uid = uuid.v4();   //Get  UUID V4
    var plaint_password = post_data.password ;  //Get password from post params
    var hash_data = saltHashPassword(plaint_password);
    var password = hash_data.passwordHash;  //Get Hash value
    var salt = hash_data.salt; //Get salt

    var name = post_data.name;
    var email = post_data.email;

    con.query('SELECT * FROM user where email=?',[email],function (err,result,fields) {
        con.on('error',function (err) {
            console.log('[MYSQL ERROR]',err);
            
        });
        if (result && result.length)
            res.json('User already exists!!!');
        else {
            con.query('INSERT INTO `user`(`unique_id`, `name`, `email`, `encrypted_password`, `salt`, `created_at`, `updated_at`) ' +
                'VALUES (?,?,?,?,?,NOW(),NOW())',[uid,name,email,password,salt],function (err,result,fields) {
                if (err) throw err;

                res.json('Register successfully !');

            })
        }
    });

})

/* LOGIN */

app.post('/login/',(req,res,next)=>{
    var post_data = req.body;

    //Extract email and password from request
    var user_password = post_data.password;
    var email = post_data.email;

    con.query('SELECT * FROM user where email=?',[email],function (err,result,fields) {
        if (result && result.length)
            {
                var salt = result[0].salt;
                var encrypted_password = result[0].encrypted_password;
                var hashed_password = checkHashPassword(user_password, salt).passwordHash;
                if (encrypted_password == hashed_password)
                    res.end(JSON.stringify(result[0]))
                else
                    res.end(JSON.stringify('Wrong Password'));
            }
        else {

                res.json('user not exists!!');

         }

    });


})


/* SHOW EVENT */
app.get('/evenement/show', (req, res) => {

    con.query('SELECT * FROM evenement ORDER BY date_debut_evenement desc',((err, results, fields) => {
        if(!err){
            res.send({ evenements:results });
        }
        else {
            console.log(err)

        }
    }))

});

/* ADD EVENT */
app.post('/evenement/add',(req,res,next)=>{
    var post_data = req.body;  //Get POST params
    var nom_evenement = post_data.nom_evenement;
    var type_evenement = post_data.type_evenement;
    var date_debut_evenement = post_data.date_debut_evenement;
    var date_fin_evenement = post_data.date_fin_evenement;
    var distance_evenement = post_data.distance_evenement;
    var photo_evenement = post_data.photo_evenement;
    var lieux_evenement = post_data.lieux_evenement;

    con.query('INSERT INTO `evenement`(`nom_evenement`, `type_evenement`, `date_debut_evenement`, `date_fin_evenement`, `distance_evenement`, `photo_evenement`, `lieux_evenement`) ' +
        'VALUES (?,?,NOW(),NOW(),?,?,?)',[nom_evenement,type_evenement,distance_evenement,photo_evenement,lieux_evenement],function (err,result,fields) {
                if (err) throw err;

                res.json('event added successfully !');

            });

    })

/* SHOW EVENT DETAILS */
app.get('/evenement/show/:id', (req, res) => {
    var post_data = req.body;  //Get POST params

    const id = req.params.id;


    con.query('SELECT * FROM `evenement` WHERE id_evenement =?' ,[id],  (error, result) => {
        if (error) throw error;

        res.send(result);
        console.log(result);
    });

});


/* DELETE EVENT*/

app.delete('/evenement/delete/:id',(req, res) => {
    const id = req.params.id;
    let sql = 'DELETE from evenement where id_evenement =?';
    let query = con.query(sql,[id],(err, result) => {
        if(err) throw err;
        res.send('Event deleted.');
    });
});

/* UPDATE EVENT */
app.put('/evenement/edit/:id', (req, res) => {

    const id = req.params.id;
    con.query('UPDATE evenement SET ? WHERE id_evenement = ?', [req.body, id], (error, result) => {
        if (error) throw error;

        res.send('Event updated successfully.');
    });
});




/*app.get("/",(req,res,next) =>{
    console.log('Password: 123456');
    var encrypt = saltHashPassword("123456");
    console.log('Encrypt: '+encrypt.passwordHash);
    console.log('Salt: '+ encrypt.salt);

})*/

//Start Server
app.listen(1337,()=>{
    console.log('Restful Running on port 1337');
})