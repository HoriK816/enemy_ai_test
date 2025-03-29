enum Direction{
  UP, LEFT, RIGHT, DOWN;
}

class MovePath{

  ArrayList<Direction> move_direction;
  ArrayList<Integer> move_speed;

  MovePath(){
    move_direction = new ArrayList<Direction>();
    move_speed = new ArrayList<Integer>();
  }

  void addPath(Direction direction, int speed){
    this.move_direction.add(direction); 
    this.move_speed.add(speed); 
  }

  // for debugging
  void printAllPath(){
    println("printAllPath()");
    println("list size : ", move_direction.size());

    for(int i = 0; i<move_direction.size(); i++){

      Direction direction = move_direction.get(i);
      int speed = move_speed.get(i);

      println("(", direction, ", ", speed,")");
    }
  }

}


class Attack extends ActionNode{

  Attack(){
    // set action name
    super("Attack", 10);
  }

  @Override
  NodeStatus Action(){
    println("this is ", name);
    println("I'm Attacking!!");

    NodeStatus status = super.Action(); 
    return status;
  }

}

// test action (debug)
class DummyAction extends ActionNode{

  DummyAction(String node_name, int required_time){
    super(node_name, required_time);
  }

  @Override
  NodeStatus Action(){
    println("this is ", name);
    println("I have finished something!");

    // decrement required time
    NodeStatus status = super.Action(); 
    return status;
  }

}


class DummyCondition extends ConditionNode{
  
  DummyCondition(String node_name){
    super(node_name);
  }

  void checkSumAnswer(){
    int sum = 0;

    for(int i = 0; i<= 10; i++){
      sum += i;
    }

    if(sum == 55){
      println("correct! sum is ", 55);

    }

    is_met = true;
  }

  @Override
  void checkCondition(){
    checkSumAnswer();
    super.checkCondition();
  }

}


class Walk extends ActionNode{
  
  Walk(){
    // set action name
    super("Walk",30);

  }

  @Override
  NodeStatus Action(){
    println("this is ", name);
    println("I'm walking!!");

    // decrement required time
    NodeStatus status = super.Action(); 
    return status;
  }

}


class EnemyWalk extends ActionNode{

  Enemy enemy;
  boolean route_calc_done = false;
  PVector dest;

  MovePath path = new MovePath();

  EnemyWalk(String node_name, int required_time, Enemy enemy){
    super(node_name, required_time);
    this.enemy = enemy;
  }

  @Override
  NodeStatus Action(){
    if(!route_calc_done){
      PVector dest = decideDestination(); 
      
      // are these parameter appropriate??? 
      calcPath(dest, enemy.position, enemy.max_speed);

      this.printPath();
    }

    
    // for debugging
    NodeStatus status = NodeStatus.SUCCESS;

    // it's correct behavior that calls super.
    /* 
    NodeStatus status = super.Action(); 
    */


    return status;
  }


  PVector decideDestination(){

    float dest_x = random(0, WINDOW_WIDTH);
    float dest_y = random(0, WINDOW_HEIGHT);

    dest = new PVector(dest_x, dest_y);
    return dest;

  }


  void printPath(){
    println("printPath()");
    this.path.printAllPath();
  }


  void calcPath(PVector dest, PVector current_position, int max_speed){

    boolean move_x_done = false;
    boolean move_y_done = false;
     
    int diff_x = (int)dest.x - (int)current_position.x;
    int diff_y = (int)dest.y - (int)current_position.y;
  
    // x direction
    while(!move_x_done){

        if(diff_x == 0){ // no need to move
          move_x_done = true;

        }else if(0 < diff_x){ // move to right

          if(abs(diff_x) < max_speed){ // move in one frame
            path.addPath(Direction.RIGHT, (int)abs(diff_x));
            move_x_done = true;

          }else{
            path.addPath(Direction.RIGHT, max_speed);
            diff_x -= max_speed;
          }

        }else{ // move to left

          if(abs(diff_x) < max_speed){ // move in one frame
            path.addPath(Direction.LEFT, (int)abs(diff_x));
            move_x_done = true;

          }else{
            path.addPath(Direction.LEFT, max_speed);
            diff_x += max_speed;
          }

        }
    }

    // y direction
    while(!move_y_done){

        if(diff_y == 0){
          move_y_done = true;

        }else if(0 < diff_y){ // move to down

          if((int)abs(diff_y) < max_speed){ // move in one frame
            path.addPath(Direction.DOWN, (int)abs(diff_y));
            move_y_done = true;

          }else{
            path.addPath(Direction.DOWN, max_speed);
            diff_y -= max_speed;
          }

        }else{ // move to up
      
          if((int)abs(diff_y)< max_speed){ // move in one frame
            path.addPath(Direction.UP, (int)abs(diff_y));
            move_y_done = true;

          }else{
            path.addPath(Direction.UP,  max_speed);
            diff_y += max_speed;
          }

        }

    }
  
    route_calc_done = true;
  }


}


