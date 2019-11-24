package com.example.miniprojetandroid.Controllers;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.Toast;

import com.example.miniprojetandroid.Entities.CampEvent;
import com.example.miniprojetandroid.Entities.pubAdapter;
import com.example.miniprojetandroid.R;
import com.special.ResideMenu.ResideMenu;
import com.special.ResideMenu.ResideMenuItem;

import java.util.ArrayList;
import java.util.List;

public class MenuActivity extends AppCompatActivity {

    ImageButton menu ;
    ResideMenu resideMenu;
    ImageView acceuil1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_menu);

        RecyclerView recyclerView = findViewById(R.id.publications);
        List<CampEvent> mlist = new ArrayList<>();
        mlist.add(new CampEvent(R.drawable.images,"haythem boudokhane",R.drawable.images));
        mlist.add(new CampEvent(R.drawable.images,"haythem boudokhane",R.drawable.images));
        mlist.add(new CampEvent(R.drawable.images,"haythem boudokhane",R.drawable.images));
        pubAdapter adapter = new pubAdapter(this,mlist );
        recyclerView.setAdapter(adapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));


        acceuil1 = findViewById(R.id.acceuil1);
        acceuil1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(MenuActivity.this, MenuActivity.class);
                startActivity(i);
            }
        });
















        menu = (ImageButton) findViewById(R.id.menu);
        setMenu();


    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {

        return resideMenu.dispatchTouchEvent(ev);
    }


    public void setMenu() {
        // attach to current activity;
        resideMenu = new ResideMenu(this);
        resideMenu.setBackground(R.drawable.gradient_bg);

        resideMenu.setShadowVisible(true);
        resideMenu.attachToActivity(this);

        // create menu items;

        String titles[] = {"Profil", "Add camp", "Logout"};
        int icon[] = {R.drawable.profile, R.drawable.profile, R.drawable.logout};

        for (int i = 0; i < titles.length; i++) {
            ResideMenuItem item = new ResideMenuItem(this, icon[i], titles[i]);
            if (titles[i] == "Profil") {
                item.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
/*                        Fragment fragg = new Haythem();
                        FragmentManager fragmentManager = getSupportFragmentManager();
                        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                        fragmentTransaction.replace(R.id.container, fragg);
                        fragmentTransaction.commit();*/
                    }
                });
            }/* else if (titles[i] == "Add camp") {
                    CampEvent.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {

                            MapSearchDialog dialog = new MapSearchDialog();
                            dialog.show(getSupportFragmentManager(), "map");


                        }
                    });
                } else if (titles[i] == "Logout") {
                    CampEvent.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            signOut();
                            // SharedPreferences loginsharedPref = getSharedPreferences(getString(R.string.app_name), Context.MODE_PRIVATE);
                            File sharedPreferenceFile = new File("/data/data/" + getPackageName() + "/shared_prefs/");
                            File[] listFiles = sharedPreferenceFile.listFiles();
                            for (File file : listFiles) {
                                file.delete();
                            }
                            finish();
                            Intent intent = new Intent(DiscoverActivity.this, LoginActivity.class);
                            startActivity(intent);
                        }
                    });

                }*/


            resideMenu.addMenuItem(item, ResideMenu.DIRECTION_LEFT); // or  ResideMenu.DIRECTION_RIGHT
        }


        resideMenu.setSwipeDirectionDisable(ResideMenu.DIRECTION_RIGHT);
        resideMenu.setSwipeDirectionDisable(ResideMenu.DIRECTION_LEFT);

        menu.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                resideMenu.openMenu(ResideMenu.DIRECTION_LEFT);
            }
        });



        resideMenu.openMenu(ResideMenu.DIRECTION_LEFT); // or ResideMenu.DIRECTION_RIGHT
        resideMenu.closeMenu();


        ResideMenu.OnMenuListener menuListener = new ResideMenu.OnMenuListener() {
            @Override
            public void openMenu() {
                Toast.makeText(getApplicationContext(), "Menu is opened!", Toast.LENGTH_SHORT).show();
            }

            @Override
            public void closeMenu() {
                Toast.makeText(getApplicationContext(), "Menu is closed!", Toast.LENGTH_SHORT).show();
            }
        };
        resideMenu.setMenuListener(menuListener);


    }





}
