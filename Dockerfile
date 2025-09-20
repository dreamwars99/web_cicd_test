# vLLM 본사에서 만든 완제품 이미지. torch, CUDA, vLLM이 모두 완벽하게 세팅되어 있음.
FROM vllm/vllm-openai:latest

# (선택사항) 나중에 HuggingFace의 비공개 모델을 쓸 때를 대비한 설정.
# GitHub Secret에 HF_TOKEN을 추가해주면 작동함. 지금은 없어도 괜찮아.
ENV HUGGING_FACE_HUB_TOKEN=${HF_TOKEN}

# 컨테이너가 실행되면, OpenAI API와 호환되는 방식으로 vLLM 서버를 시작하라는 명령어.
# --model 뒤에는 네가 최종적으로 사용할 모델 이름을 적어주면 돼.
# --port 8000은 Elastic Beanstalk가 기본적으로 사용하는 포트.
CMD ["python", "-m", "vllm.entrypoints.openai.api_server", "--model", "gpt-4o-mini", "--port", "8000"]