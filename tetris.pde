Block[] stack = new Block[1000];
int nblocks = 0;
int blocksize = 20;
int bgnd = 0;
int maxx, maxy;
int score = 0;
int end = 0;
int spd = 100;
int typenext = 0;
Char a, b;

void setup() {
    size(600, 700);
    maxx = (width - 300)/blocksize;
    maxy = height/blocksize;
    background(bgnd);
    frameRate(100);
    a = new Char();
    a.x = maxx/2;
    a.y = -3;
    typenext = floor(random(70)/10);
}

void draw() {
    if (end == 0) {
        background(bgnd);
        noStroke();
        fill(150);
        rect(300, 0, 300, height);
        fill(0);
        rect(375,20,150,150);
        textSize(20);
        textAlign(CENTER);
        text(score, 450, 200);
        printnext();
        if (frameCount % spd == 0) {
            a.mov(0, 1);
            //a.drw();
        }
        for (int i = 0; i < nblocks; i++) {
            stack[i].drw();
        }
        int nlines = 0;
        for (int i = 0; i < maxy; i++) {
            int cnt = 0;
            for (int j = 0; j < maxx; j++) {
                for (int k = 0; k < nblocks; k++) {
                    if (stack[k].x == j && stack[k].y == i && stack[k].state == 1) {
                        cnt++;
                    }
                }
            }
            if (cnt == maxx) {
                nlines++;
                for (int k = 0; k < nblocks; k++) {
                    stack[k].ers();
                    if (stack[k].y == i && stack[k].state == 1) {
                        stack[k].state = 2;
                    }
                    if (stack[k].y < i && stack[k].state == 1) {
                        stack[k].y++;
                        stack[k].drw();
                    }
                }
            }
        }
        for (int i = 0; i < nblocks; i++) {
            if (stack[i].state == 1 && stack[i].y < 0) {
                end = 1;
            }
        }
        noStroke();
        fill(0);
        rect(0, 0, 40, 20);
        score += 40*Math.pow(nlines, 2);
        if (spd > 25) {
            spd -= nlines*10;
            if(spd < 10){
            	spd = 10;
            }
        }
    }
}

void printnext() {
    Block[] next = new Block[5];
    for (int i = 0; i < 4; i++) {
        next[i] = new Block(typenext);
        next[i].x = coord[typenext][0][i] + 22;
        next[i].y = coord[typenext][1][i] + 5;
        next[i].drw();
    }
}

void keyPressed() {
    if (end == 0) {
        if (keyCode == UP) {
            a.rot();
        }
        if (keyCode == LEFT) {
            a.mov(-1, 0);
        }
        if (keyCode == RIGHT) {
            a.mov(1, 0);
        }
        if (keyCode == DOWN) {
            a.mov(0, 1);
        }
    }
    if (key == 'p') {
        if (end == 2) {
            end = 0;
        } else {
            if (end == 0) {
                end = 2;
            }
        }
    }
}

class Block {
    int state = 0, x = -1, y = -1, type;
    Block(int t) {
        type = t;
    }

    void drw() {
        int r = 0, g = 0, b = 0;
        switch (type) {
        case 0: 
            r = 0;
            g = 0;
            b = 255;
            break;
        case 1: 
            r = 255;
            g = 255;
            b = 0;
            break;
        case 2: 
            r = 255;
            g = 0;
            b = 0;
            break;
        case 3: 
            r = 0;
            g = 255;
            b = 0;
            break;
        case 4: 
            r = 0xFC;
            g = 0x6A;
            b = 0x02;
            break;
        case 5: 
            r = 0;
            g = 255;
            b = 255;
            break;
        case 6: 
            r = 255;
            g = 0;
            b = 255;
            break;
        }
        if (state != 2) {
            noStroke();
            fill(r, g, b);
            rect((x*blocksize), (y*blocksize), blocksize-2, blocksize-2);
        }
    }

    void ers() {
        noStroke();
        fill(bgnd);
        rect((x*blocksize), (y*blocksize), blocksize, blocksize);
    }
}

class vector {
    int x, y;
}

class Char {
    int begin = 0, end = 0, type = 0, x, y;
    vector[] blocks = new vector[4];
    Char() {
        for (int i = 0; i < 4; i++) {
            blocks[i] = new vector();
        }
        generate();
    }
    Char(int a) {
        for (int i = 0; i < 4; i++) {
            blocks[i] = new vector();
        }
        generate(a);
    }
    void rot() {
        vector[] buffer = new vector[4];
        for (int i = 0; i < 4; i++) {
            buffer[i] = new vector();
            buffer[i].x = blocks[i].x;
            buffer[i].y = blocks[i].y;
        }
        for (int i = 0; i < 4; i++) {
            blocks[i].x =  buffer[i].y;
            blocks[i].y = -buffer[i].x;
        }
        int st = 0;
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < nblocks; j++) {
                if (blocks[i].x + x == stack[j].x && blocks[i].y + y == stack[j].y && stack[j].state == 1) {
                    st = 1;
                }
                if (blocks[i].x + x >= maxx || blocks[i].y + y >= maxy || blocks[i].x + x < 0) {
                    st = 1;
                }
            }
        }
        if (st == 1) {
            for (int i = 0; i < 4; i++) {
                blocks[i].x = buffer[i].x;
                blocks[i].y = buffer[i].y;
            }
        }
        drw();
    }
    void mov(int xmov, int ymov) {
        x += xmov;
        y += ymov;
        vector[] buffer = new vector[4];
        for (int i = 0; i < 4; i++) {
            buffer[i] = new vector();
            buffer[i].x = blocks[i].x;
            buffer[i].y = blocks[i].y;
        }
        int st = 0;
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < nblocks; j++) {
                if (blocks[i].x + x == stack[j].x && blocks[i].y + y == stack[j].y && stack[j].state == 1) {
                    st = 1;
                }
                if (blocks[i].x + x >= maxx || blocks[i].y + y >= maxy || blocks[i].x + x < 0) {
                    st = 1;
                }
            }
        }
        if (st == 1) {
            x -= xmov;
            y -= ymov;
            if (ymov == 1) {
                generate();
            }
        }
        drw();
    }
    void update() {
        for (int i = 0; i < 4; i++) {
            stack[i+begin].x = x + blocks[i].x;
            stack[i+begin].y = y + blocks[i].y;
        }
    }
    void generate() {
        x = maxx/2;
        y = -3;
        if (end != begin) {
            for (int i = 0; i < 4; i++) {
                stack[i + begin].state = 1;
            }
        }   
        type = typenext;
        typenext = floor(random(70)/10);
        begin = nblocks;
        end = begin + 3;
        for (int i = 0; i < 4; i++) {
            stack[i+begin] = new Block(type);
            blocks[i].x = coord[type][0][i];
            blocks[i].y = coord[type][1][i];
            nblocks++;
        }
        update();
    }
    void generate(int a) {
        x = maxx/2;
        y = -3;
        if (end != begin) {
            for (int i = 0; i < 4; i++) {
                stack[i + begin].state = 1;
            }
        }       
        type = a;
        begin = nblocks;
        end = begin + 3;
        for (int i = 0; i < 4; i++) {
            stack[i+begin] = new Block(type);
            blocks[i].x = coord[type][0][i];
            blocks[i].y = coord[type][1][i];
            nblocks++;
        }
        update();
    }
    void drw() {
        for (int i = 0; i < 4; i++) {
            stack[i+begin].ers();
        }
        update();
        for (int i = 0; i < 4; i++) {
            stack[i+begin].drw();
        }
    }
    int check() {
        return 0;
    }
}
