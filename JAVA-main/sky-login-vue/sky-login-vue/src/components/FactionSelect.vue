<template>
  <div class="faction-select" ref="root">
    <button type="button" class="trigger" :class="{ empty: !modelValue, open }" @click="toggle">
      <span class="icon">{{ modelValue ? currentEmoji : '⚑' }}</span>
      <span class="txt">{{ modelValue || placeholder }}</span>
      <span class="caret" :class="{ up: open }">▾</span>
    </button>
    <transition name="drop">
      <ul v-if="open" class="panel">
        <li
          v-for="f in factions"
          :key="f.value"
          class="opt"
          :class="{ on: f.value === modelValue }"
          @click="choose(f)"
        >
          <span class="icon">{{ f.emoji }}</span>
          <span class="name">{{ f.label }}</span>
          <span class="tick" v-if="f.value === modelValue">♥</span>
        </li>
      </ul>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'

const props = defineProps({
  modelValue: { type: String, default: '' },
  placeholder: { type: String, default: '归属之境' }
})
const emit = defineEmits(['update:modelValue'])

// 光遇主题阵营：emoji 图标 + 名称
const factions = [
  { value: '光崽', label: '光崽', emoji: '🌟' },
  { value: '先祖', label: '先祖', emoji: '🕯️' },
  { value: '国王', label: '国王', emoji: '👑' }
]

const open = ref(false)
const root = ref(null)

const currentEmoji = computed(() => {
  const f = factions.find((x) => x.value === props.modelValue)
  return f ? f.emoji : '🪐'
})

function toggle() {
  open.value = !open.value
}
function choose(f) {
  emit('update:modelValue', f.value)
  open.value = false
}
function onDocClick(e) {
  if (root.value && !root.value.contains(e.target)) open.value = false
}
onMounted(() => document.addEventListener('click', onDocClick))
onBeforeUnmount(() => document.removeEventListener('click', onDocClick))
</script>

<style scoped>
.faction-select {
  position: relative;
  width: 100%;
}
/* trigger 与输入框同款：content-box + 同 padding，保证外框严格等长 */
.trigger {
  box-sizing: content-box;
  width: 100%;
  position: relative;
  display: flex;
  align-items: center;
  padding: 11px 16px 11px 44px;
  font-size: 15px;
  border-radius: 16px;
  border: 1px solid rgba(160, 190, 255, 0.3);
  background: rgba(16, 28, 66, 0.45);
  color: #f2f6ff;
  font-family: inherit;
  cursor: pointer;
  outline: none;
  transition: border-color 0.3s, background 0.3s, box-shadow 0.3s, transform 0.15s;
}
.trigger.empty .txt {
  color: rgba(210, 226, 255, 0.5);
}
.trigger:hover {
  border-color: rgba(150, 195, 255, 0.7);
  background: rgba(20, 34, 78, 0.5);
}
.trigger.open,
.trigger:focus {
  border-color: rgba(150, 195, 255, 0.95);
  box-shadow: 0 0 0 4px rgba(140, 180, 255, 0.5), 0 0 22px rgba(120, 170, 255, 0.3);
}
/* 触发框图标：仅作用于 trigger，与输入框 .ic 同套绝对定位，严格在框内、垂直居中、与其他行对齐 */
.trigger .icon {
  position: absolute;
  left: 15px;
  top: 50%;
  transform: translateY(-50%);
  width: 22px;
  text-align: center;
  font-size: 16px;
  line-height: 1;
  color: rgba(225, 235, 255, 0.85);
  filter: drop-shadow(0 0 6px rgba(255, 225, 150, 0.45));
}
.txt {
  flex: 1;
  text-align: left;
}
.caret {
  position: absolute;
  right: 16px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 15px;
  color: rgba(210, 226, 255, 0.7);
  transition: transform 0.25s;
}
.caret.up {
  transform: translateY(-50%) rotate(180deg);
}

.panel {
  position: absolute;
  z-index: 20;
  top: calc(100% + 8px);
  left: 0;
  right: 0;
  margin: 0;
  padding: 6px;
  list-style: none;
  border-radius: 16px;
  background: rgba(18, 30, 72, 0.92);
  border: 1px solid rgba(160, 190, 255, 0.35);
  box-shadow: 0 16px 40px rgba(4, 10, 32, 0.6);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
}
.opt {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 12px;
  border-radius: 12px;
  cursor: pointer;
  color: #f2f6ff;
  transition: background 0.2s, transform 0.15s;
}
.opt:hover {
  background: rgba(140, 180, 255, 0.18);
  transform: translateX(3px) scale(1.02);
}
.opt.on {
  background: rgba(150, 195, 255, 0.22);
}
.opt .name {
  flex: 1;
  font-size: 14px;
}
/* 下拉选项图标：流入 flex 子项，跟随名称左侧，不与文字重叠 */
.opt .icon {
  position: static;
  flex: 0 0 auto;
  width: auto;
  text-align: center;
  font-size: 16px;
  line-height: 1;
  color: rgba(225, 235, 255, 0.9);
  filter: drop-shadow(0 0 6px rgba(255, 225, 150, 0.45));
}
.opt .tick {
  color: #ffd27a;
  font-size: 13px;
}

.drop-enter-active,
.drop-leave-active {
  transition: opacity 0.22s, transform 0.22s;
}
.drop-enter-from,
.drop-leave-to {
  opacity: 0;
  transform: translateY(-8px) scale(0.96);
}
</style>
