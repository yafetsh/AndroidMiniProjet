package com.example.miniprojetandroid;

import androidx.appcompat.app.AppCompatActivity;

import android.content.DialogInterface;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Toast;

import com.afollestad.materialdialogs.MaterialDialog;
import com.example.miniprojetandroid.Retrofit.INodeJS;
import com.example.miniprojetandroid.Retrofit.RetrofitClient;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.dialog.MaterialAlertDialogBuilder;
import com.rengwuxian.materialedittext.MaterialEditText;

import io.reactivex.Scheduler;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Retrofit;

public class MainActivity extends AppCompatActivity {
    INodeJS myAPI;
    CompositeDisposable compositeDisposable = new CompositeDisposable();

    MaterialEditText edt_email,edt_password;
    MaterialButton btn_register,btn_login;




    @Override
    protected void onStop() {
        compositeDisposable.clear();
        super.onStop();
    }

    @Override
    protected void onDestroy() {
        compositeDisposable.clear();
        super.onDestroy();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //Init API
        Retrofit retrofit = RetrofitClient.getInstance();
        myAPI = retrofit.create(INodeJS.class);

        //View
        btn_login = findViewById(R.id.login_button);
        btn_register = findViewById(R.id.register_button);

        edt_email = findViewById(R.id.edt_email);
        edt_password = findViewById(R.id.edt_password);

        //Button action
        btn_login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                 loginUser(edt_email.getText().toString(),edt_password.getText().toString());
            }
        });

        btn_register.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                registerUser(edt_email.getText().toString(),edt_password.getText().toString());

            }
        });


    }

    private void registerUser(final String email, final String password) {
        final View enter_name_view = LayoutInflater.from(this).inflate(R.layout.enter_name_layout,null);
        new MaterialAlertDialogBuilder(MainActivity.this)
                .setTitle("Register")
                .setCustomTitle(enter_name_view)
                .setIcon(R.drawable.ic_action_name)
                .setMessage("One More Step")
                .setPositiveButton("Register", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        MaterialEditText edt_name = enter_name_view.findViewById(R.id.edt_name);
                        compositeDisposable.add(myAPI.registerUser(email,edt_name.getText().toString(),password)
                        .subscribeOn(Schedulers.io())
                                .observeOn(AndroidSchedulers.mainThread())
                                .subscribe(new Consumer<String>() {
                                    @Override
                                    public void accept(String s) throws Exception {
                                        Toast.makeText(MainActivity.this,""+s,Toast.LENGTH_SHORT).show();
                                    }
                                })
                        );

                    }
                })

                .show();
    }

    private void loginUser(String email, String password) {
        compositeDisposable.add(myAPI.loginUser(email,password)
        .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                        if (s.contains("encrypted_password"))
                            Toast.makeText(MainActivity.this,"Login Successfully",Toast.LENGTH_SHORT).show();
                        else
                            Toast.makeText(MainActivity.this,""+s,Toast.LENGTH_SHORT).show(); //Show error from API

                    }
                })
        );
    }
}
