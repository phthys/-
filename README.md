## 타이머 구현
- 2021.06 대학 과제로 진행한 것.
- vivado(verilog), FPGA(EasySoc-Z7010 보드 사용)로 미니 프로젝트 진행했던 것 정리해놓은 것
- 기록용으로 남겨 놓음.
- source 코드랑 제출했던 레포트.   
- 프로젝트 내용은 아래 내용과 같음   
![image](https://user-images.githubusercontent.com/96903347/167577260-92ccad02-625a-496c-9436-fb4355039ec6.png)   

## 코드 간단 설명
- bcd_to_7seg.v : 숫자 0~9 를 binary coded decimal 이진화 십진법의 형태로 입력받아서, 7 segment의 형태로 바꿔준다.
- counter.v : 클럭을 통해 시간간격을 조절
- debounce.v : 버튼 입력 시 생기는 파형의 진동으로 인해 버튼 입력이 여러번 들어가는 문제를 해결하기 위함. 버튼 한번 누르면 한번만 입력되도록.
- increase.v : inc 버튼 입력 시 숫자가 증가함.
- next.v : next 버튼 입력 시 다음 숫자로 넘어감.
- nreset.v : reset 버튼 입력 시 리셋.
- timer.v : 타이머 구현 코드
