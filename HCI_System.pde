//Sistema de Gestão Habitacional - Trabalho de grupo - Teresa Paulino, Jorge Díaz e André Ribeiro
//Interação Humano-Computador
//Universidade da Madeira 
//Programado por Teresa Paulino e Jorge Díaz 30-05-2014
//V1.0

PImage[][] botoes = new PImage[5][8];/*este array armazena todos os botões simples que ainda não foram pressionados
temos 5 botões no menu principal, e no máximo temos 7 botões no sub-menu, por exemplo o botão das luzes
pode ser encontrado na posição [0][2]: 0 - iluminação (primeira opção) e 2 - luzes (segunda opção que aparece no menu)
depois de a iluminação ter sido escolhida 
(NOTA: o array armazena 8 sub-opções e não 7 devido aos nomes das imagens-  0.0 corresponde à 1ª posição
no menu principal e 0.1 corresponde à primeira posição no subMenu (da primeira opção do menu principal)
*/

PImage[][] botoesP = new PImage[5][8];//idêntico ao array anterior mas refere-se aos botões pressionados

PImage[] atalhos = new PImage[6];
PImage[] atalhosP = new PImage[6];
PImage[] imgCirculos = new PImage[3];
PImage[] circulos = new PImage[13];
PImage[] imgAtalhos = new PImage[6];
PImage[] camaras = new PImage[23];
PImage[] imgCamaras = new PImage[9];
PImage cozinhaControls  = new PImage();
PImage irrigacao = new PImage();

/*arrays que armazenam as coordenadas onde vão ser localizados os círculos que indicam a presença de equipamentos
por razões de simplicidade diferencia-se apenas a divisão onde estão colocados os equipamentos
considerando apenas 1 por divisão ou localização, sendo que nas divisões que têm, por exemplo, mais do que 1 porta
é controlável apenas a porta principal*/
int[] localX = {450, 580, 450, 580, 445, 580, 680, 690, 392, 820, 820, 310, 310};
int[] localY = {275, 190, 190, 285, 375, 375, 200, 355, 290, 125, 365, 365, 200};

PImage infoBar;
PImage controlsBar;
PImage plant;

PFont font;

//a variável opcao indica qual opção foi selecionada no menu principal
int opcao = -1;

//a variável subMenu indica qual a opção selecionada no sub-menu
int subMenu = 1;

//variáveis que ajudam na indicação de quais os círculos a apresentar sobre a planta
//ao todo são 13 circulos
//diferentes opções apresentam diferentes nº de círculos
int numeroI = 0;
int numeroF = 13;

//variável que ajuda a indicar quando a barra de controlos deve ser apresentada e também indica o nº de círculos selecionados
int control = 0;

//a utilização da opção sistema é diferente das outras opções, não necessita da planta
//e será utilizado esse espaço para apresentar, por exemplo, a lista de utilizadores ou de equipamentos
//a variável sistema ativa/desativa essa opção
boolean sistema = false;

//atalho selecionado
int atalho = 2;

//scrollbar
HScrollbar hs1;

//Fogão scrollbars
HScrollbar fogao1;
HScrollbar fogao2;
HScrollbar fogao3;
HScrollbar fogao4;

//Irrigação scrollbar
HScrollbar irrigacaoS;

//variável para data e horas
int hora = 0;
int minutos = 0;
int dia =1;
int mes = 1;

int horaIni = 0;
int minutosIni = 0;
int horaFim = 0;
int minutosFim = 0;

boolean isPlay = false;

void setup()
{
  size(1024,600);
  imageMode (CENTER);
  background(loadImage("bg.jpg"));
  infoBar = loadImage( "infoBar.png");
  controlsBar = loadImage( "controlsBar.png");
  plant = loadImage( "plant.png");
  font = loadFont ("Sansation_Light-48.vlw");
  irrigacao = loadImage("irrigacao.png");
  textFont (font, 16);
  hs1 = new HScrollbar(315, 530, 500, 1, 1);
  fogao1 = new HScrollbar(330, 510, 200, 1, 1);
  fogao2 = new HScrollbar(330, 548, 200, 1, 1);
  fogao3 = new HScrollbar(650, 510, 200, 1, 1);
  fogao4 = new HScrollbar(650, 548, 200, 1, 1);
  irrigacaoS = new HScrollbar(294, 535, 220, 1, 1);
  
  //ciclos que preenchem os arrays com as imagens
  for (int i = 0; i < 5; i++)
  {
    for (int j = 0; j<8; j++)
    {
      botoes[i][j] = loadImage( "btn" + i + "." + j + ".png");
      if (botoes[i][j] == null){
        botoes[i][j] = loadImage( "blank.png");
      }
    }
  }
  
  for (int i = 0; i < 5; i++)
  {
    for (int j = 0; j<8; j++)
    {
      botoesP[i][j] = loadImage( "btnP" + i + "." + j + ".png");
    }
  }
  
  for (int i = 0; i < 3; i++)
  {
    imgCirculos[i] = loadImage( "Circle" + i + ".png");
  }
  
  for (int i = 0; i < 13; i++)
  {
    circulos[i] = imgCirculos[0];
  }
  
  for (int i = 0; i < 6; i++)
  {
    atalhos[i] = loadImage( "atalho" + i + ".png");
    atalhosP[i] = loadImage( "atalhoP" + i + ".png");
    imgAtalhos[i] = loadImage( "imgAtalho" + i + ".png");
  }
  
  for (int i = 0; i < 23; i++)
  {
    camaras[i] = loadImage("camaras" + i + ".png");
  }
  
  for (int i = 0; i < 9; i++)
  {
    imgCamaras[i] = loadImage("imgCamaras" + i + ".png");
  }
  
  cozinhaControls = loadImage("cozinhaControls.png");
}

void draw()
{
  background(loadImage("bg.jpg"));  
  numCirculos();
  menu();
  atalhos();
  //println(opcao);
  //println(subMenu);
  println(mouseX);
  println(mouseY);
  dataEhora();
  
  //se o(s) equipamento(s) já foi ou foram selecionados, então são apresentados os controles
  if (control > 0)
  {
    controls();
  }
  
  if (sistema)
  {
    opcaoSistema();
  }
  
  if(isPlay)
  {
    playCamaras();
  }
  //Calls mouseOver function
  mouseOver();
}

//Função que muda o ícone quando o rato estiver sobre ele
void mouseOver()
{
  if (mouseX > 30 && mouseX < 200)
  {
    if (mouseY > 90 && mouseY < 130)
    {
      if (opcao == -1 || opcao == 4){
        image(botoesP[0][1], width/2, height/2);
    }
  }
      
  if (mouseY > 155 && mouseY < 190)
  {
    if (opcao == -1 || opcao == 4)
    {
      image(botoesP[1][0], width/2, height/2);
    }
    else if(opcao == 0)
    {
       image(botoesP[0][2], width/2, height/2);
    }
    else if(opcao == 1)
    {
       image(botoesP[1][2], width/2, height/2);
     
    }
    else if(opcao == 2)
    {
       image(botoesP[2][2], width/2, height/2);
    }
    else if(opcao == 3)
    {
       image(botoesP[3][2], width/2, height/2);
    }
  }
        
  if (mouseY > 220 && mouseY < 260)
  {
    if (opcao == -1 || opcao == 4)
    {
      image(botoesP[2][0], width/2, height/2);
    }
    else if(opcao == 0)
    {
      image(botoesP[0][3], width/2, height/2);
    }
    else if(opcao == 1)
    {
      image(botoesP[1][3], width/2, height/2);
    }
    else if(opcao == 2)
    {
      image(botoesP[2][3], width/2, height/2);
    }
    else if(opcao == 3)
    {
      image(botoesP[3][3], width/2, height/2);
    }
  }
      
  if (mouseY > 285 && mouseY < 325)
  {
    if (opcao == -1 || opcao == 4)
    {
      image(botoesP[3][0], width/2, height/2);
    }
    else if(opcao == 1)
    {
      image(botoesP[1][4], width/2, height/2);
    }
    else if(opcao == 2)
    {
      image(botoesP[2][4], width/2, height/2);
    }
    else if(opcao == 3)
    {
      image(botoesP[3][4], width/2, height/2);
    }
  }
      
  if (mouseY > 350 && mouseY < 390)
  {
    if (opcao == -1)
    {
      image(botoesP[4][0], width/2, height/2);
    }
    else if(opcao == 1)
    {
       image(botoesP[1][5], width/2, height/2);
    }
    else if(opcao == 2)
    {
       image(botoesP[2][5], width/2, height/2);
    }
  }
      
    if (mouseY > 415 && mouseY < 450 && opcao == 1)
    {
      image(botoesP[1][6], width/2, height/2);
    } 
    
    if (mouseY > 475 && mouseY < 515 && opcao == 1)
    {
      image(botoesP[1][7], width/2, height/2);
    }
  }
  
  for (int c = numeroI; c < numeroF; c ++)
  {
    if (mouseX > localX[c] - 15 && mouseX < localX[c] + 15 && mouseY > localY[c] - 15 && mouseY < localY[c] + 15)
    {
        if (circulos[c] == imgCirculos[0])
        {
          circulos[c] = imgCirculos[2];
        }
    }
    else if (circulos[c] == imgCirculos[2])
    {
      circulos[c] = imgCirculos[0];
    }
  }
  
  if (mouseX > 934 && mouseX < 990)
  {
    if (mouseY > 100 && mouseY < 152)
    {
      image(atalhosP[5], width/2, height/2);
    }
    
    if (mouseY > 178 && mouseY < 245)
    {
      image(atalhosP[4], width/2, height/2);
    }
    
    if (mouseY > 275 && mouseY < 340)
    {
      image(atalhosP[3], width/2, height/2);
    }
    
    if (mouseY > 355 && mouseY < 425)
    {
      image(atalhosP[2], width/2, height/2);
    }
  }
  
  if (mouseX > 925 && mouseX < 955)
  {
    if (mouseY > 460 && mouseY < 490)
    {
      image(atalhosP[0], width/2, height/2);
    }
  }
  
  if (mouseX > 988 && mouseX < 1011)
  {
    if (mouseY > 460 && mouseY < 490)
    {
      image(atalhosP[1], width/2, height/2);
    }
  }
  
  if(opcao == 2 && subMenu == 5 || opcao == 4)
  {
    if(mouseX > 689 && mouseX < 707)
    {
      if(mouseY > 535 && mouseY < 546)
      image(camaras[7], width/2, height/2);
      
      if(mouseY > 550 && mouseY < 560)
      image(camaras[8], width/2, height/2);
      
      if(mouseY > 500 && mouseY < 509)
      image(camaras[13], width/2, height/2);
      
      if(mouseY > 513 && mouseY < 523)
      image(camaras[14], width/2, height/2);
    }
    
    if(mouseX > 742 && mouseX < 760)
    {
      if(mouseY > 535 && mouseY < 546)
      image(camaras[9], width/2, height/2);
      
      if(mouseY > 550 && mouseY < 560)
      image(camaras[10], width/2, height/2);
      
      if(mouseY > 500 && mouseY < 509)
      image(camaras[15], width/2, height/2);
      
      if(mouseY > 513 && mouseY < 523)
      image(camaras[16], width/2, height/2);
    }
  }
  if(opcao == 2 && subMenu == 5)
  {
    if(mouseY > 517 && mouseY < 540)
    {
      if(mouseX > 780 && mouseX < 805)
      {
        image(camaras[19], width/2, height/2);
      }
      if(mouseX > 826 && mouseX < 836 && isPlay == false)
      {
        image(camaras[17], width/2, height/2);
      }
      else if(mouseX > 826 && mouseX < 836 && isPlay == true)
      {
        image(camaras[20], width/2, height/2);
      }
      if(mouseX > 860 && mouseX < 883)
      {
        image(camaras[18], width/2, height/2);
      }
    }
  }
}

//função que altera as variáveis opcao e subMenu consoante o local onde o rato é pressionado
//de acordo com as posições dos diferentes botões
void mousePressed()
{
  
  if (mouseX > 30 && mouseX < 200)
    {
      resetCirculos();
      control = 0;
      sistema = false;
      atalho = -1;
      
      if (mouseY > 90 && mouseY < 130)
      {
        if (opcao == -1 || opcao == 4)
        {
          opcao = 0;
        }
        else
        {
          opcao = -1;
          subMenu = 1;
        }
      }
      
      if (mouseY > 155 && mouseY < 190)
      {
        if (opcao == -1 || opcao == 4)
        {
          opcao = 1;
        }     
        else 
        {
          subMenu = 2;
        } 
      }
    
      if (mouseY > 220 && mouseY < 260)
      {
        if (opcao == -1 || opcao == 4)
        {
          opcao = 2;
        }
        else 
        {
          subMenu = 3;
        } 
      }
        
      if (mouseY > 285 && mouseY < 325)
      {
        if (opcao == -1 || opcao == 4)
        {
          opcao = 3;
        }
        else 
        {
          subMenu = 4;
        } 
      }
        
      if (mouseY > 350 && mouseY < 390)
      {
        if (opcao == -1)
        {
          opcao = 4;
        }
        else {
          subMenu = 5;
        } 
      }
        
      if (mouseY > 415 && mouseY < 450 && opcao == 1)
      {
        subMenu = 6;
      } 
        
      if (mouseY > 475 && mouseY < 515 && opcao == 1)
      {
        subMenu = 7;
      }
  }
  
  //ciclo que deteta se o rato está a pressionar nalgum círculo
  //se sim, altera a cor do círculo e aumenta a variavel control --> nº de círculos selecionados
  for (int c = numeroI; c < numeroF; c ++)
  {
    if (mouseX > localX[c] - 15 && mouseX < localX[c] + 15)
    {
      if (mouseY > localY[c] - 15 && mouseY < localY[c] + 15)
      {
        if (circulos[c] == imgCirculos[0] || circulos[c] == imgCirculos[2])
        {
          circulos[c] = imgCirculos[1];
          control ++;
        }
        
        //caso o equipamento (circulo) já tiver sido selecionado
        //volta a colocar o círculo da cor original e reduz o nº de circulos selecionados
        else
        {
          circulos[c] = imgCirculos[0];
          control --;
        }
      }
    }
  }
  
  
  //Seleção de atalhos
  if (mouseX > 934 && mouseX < 990)
  {
    resetMenu();
    if (mouseY > 100 && mouseY < 152)
    {
      atalho = 5;
    }
    
    if (mouseY > 178 && mouseY < 245)
    {
      atalho = 4;
    }
    
    if (mouseY > 275 && mouseY < 340)
    {
      atalho = 3;
    }
    
    if (mouseY > 355 && mouseY < 425)
    {
      atalho = 2;
    }
  }
  
  if (mouseX > 925 && mouseX < 955)
  {
    resetMenu();
    if (mouseY > 460 && mouseY < 490)
    {
      atalho = 0;
    }
  }
  
  if (mouseX > 988 && mouseX < 1011)
  {
    resetMenu();
    if (mouseY > 460 && mouseY < 490)
    {
      atalho = 1;
    }
  }
  
  if(opcao == 2 && subMenu == 5)
  {
    if(mouseX > 689 && mouseX < 707)
    {
      if(mouseY > 535 && mouseY < 546)
      {
        if(hora < 23)
        {
          hora++;
        }
        else
        {
          hora = 0;
        }
      }
      
      if(mouseY > 550 && mouseY < 560)
      {
        if(hora != 0)
        {
          hora--;
        }
        else
        {
          hora = 23;
        }
      }
      
      if(mouseY > 500 && mouseY < 509)
      if((mes == 1 || mes == 3 || mes == 5 || mes == 7 || mes == 8 || mes == 10 || mes == 12) && dia < 31)
      {
        dia++;
      }
      else if ((mes == 4 || mes == 6 || mes == 9 || mes == 11) && dia < 30)
      {
        dia++;
      }
      else if (mes == 2 && dia < 29)
      {
        dia++;
      }
      else
      {
        dia = 1;
      }
      
      if(mouseY > 513 && mouseY < 523)
      if (dia != 1)
      {
        dia--;
      }
      else if((mes == 1 || mes == 3 || mes == 5 || mes == 7 || mes == 8 || mes == 10 || mes == 12) && dia == 1)
      {
        dia = 31;
      }
      else if ((mes == 4 || mes == 6 || mes == 9 || mes == 11) && dia == 1)
      {
        dia = 30;
      }
      else if (mes == 2 && dia == 1)
      {
        dia = 29;
      }
    }
    
    if(mouseX > 742 && mouseX < 760)
    {
      if(mouseY > 535 && mouseY < 546)
      {
        if(minutos < 59)
        {
          minutos++;
        }
        else
        {
          minutos = 0;
        }
      }
      
      if(mouseY > 550 && mouseY < 560)
      {
        if(minutos != 0)
        {
          minutos--;
        }
        else
        {
          minutos = 59;
        }
      }
      
      if(mouseY > 500 && mouseY < 509)
      {
        if(mes < 12)
        {
          mes++;
        }
        else
        {
          mes = 1;
        }
      }
      
      if(mouseY > 513 && mouseY < 523)
      {
        if(mes != 1)
        {
          mes--;
        }
        else
        {
          mes = 12;
        }
      }
    }
    if(mouseX > 826 && mouseX < 836 && isPlay == false)
      {
        isPlay = true;
      }
      else if (mouseX > 826 && mouseX < 836 && isPlay == true)
      {
        isPlay = false;
      }
  }
  
  if(opcao == 4)
  {
    if(mouseX > 689 && mouseX < 707)
    {
      if(mouseY > 535 && mouseY < 546)
      {
        if(horaFim < 23)
        {
          horaFim++;
        }
        else
        {
          horaFim = 0;
        }
      }
      
      if(mouseY > 550 && mouseY < 560)
      {
        if(horaFim != 0)
        {
          horaFim--;
        }
        else
        {
          horaFim = 23;
        }
      }
      
      if(mouseY > 500 && mouseY < 509)
      if(horaIni < 23)
        {
          horaIni++;
        }
        else
        {
          horaIni = 0;
        }
      
      if(mouseY > 513 && mouseY < 523)
      if(horaIni != 0)
        {
          horaIni--;
        }
        else
        {
          horaIni = 23;
        }
    }
    
    if(mouseX > 742 && mouseX < 760)
    {
      if(mouseY > 535 && mouseY < 546)
      {
        if(minutosFim < 59)
        {
          minutosFim++;
        }
        else
        {
          minutosFim = 0;
        }
      }
      
      if(mouseY > 550 && mouseY < 560)
      {
        if(minutosFim != 0)
        {
          minutosFim--;
        }
        else
        {
          minutosFim = 59;
        }
      }
      
      if(mouseY > 500 && mouseY < 509)
      {
        if(minutosIni < 59)
        {
          minutosIni++;
        }
        else
        {
          minutosIni = 0;
        }
      }
      
      if(mouseY > 513 && mouseY < 523)
      {
        if(minutosIni != 0)
        {
          minutosIni--;
        }
        else
        {
          minutosIni = 59;
        }
      }
    }
  }
}

//Determina quais as imagens que irão ser mostradas dependedendo da quantidade de câmaras selecionadas
void playCamaras()
{
  if(control == 1)
    image(imgCamaras[0], width/2, height/2);
  if(control == 2)
    image(imgCamaras[1], width/2, height/2);
  if(control == 3)
    image(imgCamaras[2], width/2, height/2);
  if(control == 4)
    image(imgCamaras[3], width/2, height/2);
  if(control == 5)
    image(imgCamaras[4], width/2, height/2);
  if(control == 6)
    image(imgCamaras[5], width/2, height/2);
  if(control == 7)
    image(imgCamaras[6], width/2, height/2);
  if(control == 8)
    image(imgCamaras[7], width/2, height/2);
  if(control == 9)
    image(imgCamaras[8], width/2, height/2);
}

//função que altera os valores das variáveis numeroI (número inicial) e numeroF (numero final) consoante o número de círculos a apresentar
void numCirculos()
{
  if((opcao == 0 && subMenu == 2) || (opcao == 2 && subMenu == 5))
  {
    numeroI = 0;
    numeroF = 9;
  }
  
  if(((opcao == 0 || opcao == 1) && subMenu == 2) || (opcao ==2 && subMenu == 3))
  {
    numeroI = 0;
    numeroF = 7;
  }
  
  if((opcao >= 3) || (opcao == 1 && subMenu >= 3) || (opcao == 2 && subMenu == 4))
  {
    numeroI = 0;
    numeroF = 0;
  }
  
  if(opcao == 2 && subMenu == 2)
  {
    numeroI = 1;
    numeroF = 7;
  }
  
  if(opcao == 4)
  {
    numeroI = 9;
    numeroF = 13;
  }
}

//navegação e apresentação das diferentes opções na interface
void menu()
{
  //apresentação dos controlos no caso de não ser necessário apresentar localização de equipamentos na planta
  if ((opcao == 1 && subMenu >= 3) || (opcao == 2 && subMenu == 4))
  {
    control ++;
  }
  
  //menu principal sem nenhuma opção selecionada
  if (opcao == -1)
  {
    for (int i = 0; i < 5; i++)
    {
      if (atalho == 2 || atalho == -1)
      {
        image(imgAtalhos[2], width/2, height/2);
        text ("Bem vindo ao sistema de gestão habitacional mais inteligente!", 270 , 60);
      }
      else if (atalho == 5)
      {
        text ("Telefone", 270 , 60);
      }
      else if (atalho == 4)
      {
        text ("Televisão", 270 , 60);
      }
      else if (atalho == 3)
      {
        text ("Computador", 270 , 60);
      }
      else if (atalho == 0)
      {
        text ("Notificações", 270 , 60);
      }
      else if (atalho == 1)
      {
        text ("Ajuda", 270 , 60);
      }
      else
      {
        text ("Bem vindo ao sistema de gestão habitacional mais inteligente!", 270 , 60);
      }
      image(infoBar, width/2, height/2);
      image(botoes[i][0], width/2, height/2);
    }
  }
  
  //menu principal com a irrigação selecionada
  //única opção que não tem sub menu
  else if(opcao == 4)
  {
    for (int i = 0; i < 5; i++)
    {
      if (atalho!=2)
      {
        image(plant, width/2, height/2); 
        if (control == 0)
        {
          text ("Escolha o dispositivo a controlar.", 270 , 60);
          hora = 0;
          minutos = 0;
          dia = 0;
          mes = 0;
        }
      }
      image(infoBar, width/2, height/2);
      image(botoes[i][0], width/2, height/2);
      image(botoesP[opcao][0], width/2, height/2);
      for (int j = numeroI; j < numeroF; j++)
      {
        image(circulos[j], localX[j], localY[j]);
      }
    }
  }
  
  //apresentação do sub menu consoante a opção selecionada
  else if(subMenu != 1 && opcao != 4)
  {
    for (int i = 1; i < 8; i++)
    {
      if (opcao != 3 && subMenu >1 && atalho!=2)
      {
        image(plant, width/2, height/2);
        //no caso de se selecionar a opção 3, sistema, a planta não aparece e é substituída 
        //pela lista de utilizadores ou de equipamentos por exemplo
        
        //se o utilizador ainda não tiver selecionado nenhum "círculo":
        if (control == 0)
        {
          text ("Escolha o(s) dispositivo(s) que deseja controlar.", 270 , 60);
        }
      }  
      else
      {
        sistema = true;
        control ++;
      }
      image(infoBar, width/2, height/2);
      image(botoes[opcao][i], width/2, height/2);
      image(botoesP[opcao][1], width/2, height/2);
      image(botoesP[opcao][subMenu], width/2, height/2);
      for (int j = numeroI; j < numeroF; j++)
      {
        image(circulos[j], localX[j], localY[j]);
      }
    }
  }
  
  //apresentação do submenu
  else
  {
    for (int i = 1; i < 8; i++)
    {
      if (opcao != 3 && atalho!=2)
      {
        image(plant, width/2, height/2);
        text ("Escolha o tipo de equipamento", 270 , 60);
      }
      else
      {
        text ("Escolha uma opção", 270 , 60);
      }
      image(infoBar, width/2, height/2);
      image(botoesP[opcao][1], width/2, height/2);
      image(botoes[opcao][i], width/2, height/2);
    }
  }
}

//função que volta a colocar os círculos como não selecionados
void resetCirculos()
{
  for (int i = 0; i < 13; i++)
  {
    circulos[i] = imgCirculos[0];
  }
}

void controls()
{ 
  if (opcao != 3)
  {
    text ("Pode agora controlar o(s) equipamento(s) selecionado(s)", 270 , 60);
  }
  image(controlsBar, width/2, height/2);
  
  //Luzes
  if ((opcao == 0 && subMenu == 2))
  {
    text("Intensidade", 520, width/2);
    text("+", 850, width/2 + 15);
    text("-", 280, width/2 + 15);
    hs1.update();
    hs1.display();
  }
  
  //Câmaras de vigilância
  if(opcao == 2 && subMenu == 5)
  {
    image(camaras[0], width/2, height/2);
  
    if(isPlay == false)
    {
      for (int i = 1; i < 4; i++)
      {  
        image(camaras[i], width/2, height/2);
      }
    }
    else
    {
      for (int i = 2; i < 5; i++)
      {  
        image(camaras[i], width/2, height/2);
      }
     }
  
    for (int i = 5; i < 7; i++)
    {
      image(camaras[i], width/2, height/2);
    }
    
    image(camaras[11], width/2, height/2);
    image(camaras[12], width/2, height/2);
  
  
    if(hora < 10)
    {
      text("0" + hora, 667, 551);
    }
    else
    {
      text(hora, 667, 551);
    }
  
    if(dia < 10)
    {
      text("0" + dia, 667, 515);
    }
    else
    {
      text(dia, 667, 515);
    }
  
    if(minutos < 10)
    {
      text("0" + minutos, 720, 551);
    }
    else
    {
      text(minutos, 720, 551);
    }
  
    if(mes < 10)
    {
      text("0" + mes, 720, 515);
    }
    else
    {
      text(mes, 720, 515);
    }
  
    if ((mes == 4 || mes == 6 || mes == 9 || mes == 11) && dia == 31)
    dia = 1;
  
    if (mes == 2 && dia > 29)
    dia = 1;
  }
  
  else
  {
    isPlay = false;
  }
  
  //Irrigação
  if(opcao == 4)
  {
    image(irrigacao, width/2, height/2);
    image(camaras[5], width/2, height/2);
    image(camaras[6], width/2, height/2);
    image(camaras[11], width/2, height/2);
    image(camaras[12], width/2, height/2);
    
    irrigacaoS.update();
    irrigacaoS.display();
    
    fill(255);
    if(horaFim < 10)
    {
      text("0" + horaFim, 667, 551);
    }
    else
    {
      text(horaFim, 667, 551);
    }
  
    if(horaIni < 10)
    {
      text("0" + horaIni, 667, 515);
    }
    else
    {
      text(horaIni, 667, 515);
    }
  
    if(minutosFim < 10)
    {
      text("0" + minutosFim, 720, 551);
    }
    else
    {
      text(minutosFim, 720, 551);
    }
  
    if(minutosIni < 10)
    {
      text("0" + minutosIni, 720, 515);
    }
    else
    {
      text(minutosIni, 720, 515);
    }
  }
  
  //Fogão 
  if(opcao == 1 && subMenu == 6)
  {
    fogao1.update();
    fogao1.display();
    fogao2.update();
    fogao2.display();
    fogao3.update();
    fogao3.display();
    fogao4.update();
    fogao4.display();
    image(cozinhaControls, width/2, height/2);
  }
}

void opcaoSistema()
{
  if (subMenu == 2)
  {
    text ("Lista de Utilizadores.", 270 , 160);
  }
  else if (subMenu == 3)
  {
    text ("Lista de Equipamentos.", 270 , 160);
  }
  else if (subMenu == 4)
  {
    text ("Gráficos com estatísticas de utilização.", 270 , 160);
  }
}

void atalhos()
{
  for (int i = 0; i < 6; i++)
  {
    image(atalhos[i], width/2, height/2);
  }
  if (atalho >= 0)
  {
    image(imgAtalhos[atalho], width/2, height/2);
  }
}

void resetMenu()
{
  opcao = -1;
  subMenu = 1;
  control = 0;
  resetCirculos();
  sistema = false;
  isPlay = false;
}

void dataEhora()
{
  fill(255);
  int d = day();   
  int m = month();  
  int y = year();   
  int min = minute();  
  int h = hour(); 
  int s = second();
  String mi = String.valueOf(m);
  String se = String.valueOf(s);
  if (min <10)
  {
    mi = "0" + min;
  }
  else
  {
    mi = String.valueOf(min);
  }
  if (s <10)
  {
    se = "0" + s;
  }
  else
  {
    se = String.valueOf(s);
  }
  text(d + "/" + m + "/" + y, 880, 590);
  text(h + ":" + mi + ":" + se, 950, 590);
}
