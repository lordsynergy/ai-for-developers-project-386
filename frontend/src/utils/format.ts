export const dayNames: Record<number, string> = {
  1: 'Понедельник',
  2: 'Вторник',
  3: 'Среда',
  4: 'Четверг',
  5: 'Пятница',
  6: 'Суббота',
  7: 'Воскресенье',
};

export function formatDateTime(value: string) {
  return new Intl.DateTimeFormat('ru-RU', {
    dateStyle: 'medium',
    timeStyle: 'short',
  }).format(new Date(value));
}

export function formatTimeRange(start: string, end: string) {
  return `${formatDateTime(start)} - ${formatDateTime(end)}`;
}

export function formatTime(value: string) {
  return value.slice(11, 16);
}

export function formatDate(value: string) {
  return new Intl.DateTimeFormat('ru-RU', {
    weekday: 'long',
    day: 'numeric',
    month: 'long',
  }).format(new Date(value));
}

export function formatMonthYear(value: string) {
  if (!value) return '';
  const month = new Intl.DateTimeFormat('ru-RU', { month: 'long' }).format(new Date(value));
  const year = value.slice(0, 4);
  return `${month} ${year}`;
}

export function toDateKey(value: string) {
  return value.slice(0, 10);
}
