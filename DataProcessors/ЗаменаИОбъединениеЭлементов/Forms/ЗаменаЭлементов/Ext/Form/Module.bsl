﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Форма параметризуется.
//
// Параметры:
//     НаборСсылок - Массив, СписокЗначений - набор элементов для анализа.
//                                            Может быть коллекцией элементов, обладающих полем "Ссылка".
//

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ОткрытаПоСценарию") Тогда
		ВызватьИсключение НСтр("ru = 'Обработка не предназначена для непосредственного использования.'");
	КонецЕсли;
	
	// Перекладываем параметры в таблицу ЗаменяемыеСсылки. 
	// Инициализируем реквизиты ЦелевойЭлемент, ОбщийВладелецЗаменяемыхСсылок, ТекстОшибкиПараметров.
	ИнициализироватьЗаменяемыеСсылки(МассивСсылокИзСписка(Параметры.НаборСсылок));
	Если Не ПустаяСтрока(ТекстОшибкиПараметров) Тогда
		Возврат; // Будет выдано предупреждение при открытии.
	КонецЕсли;
	
	ЕстьПравоБезвозвратногоУдаления = ПравоДоступа("АдминистрированиеДанных", Метаданные);
	СобытиеОповещенияОЗамене        = Обработки.ЗаменаИОбъединениеЭлементов.СобытиеОповещенияОЗамене();
	ТекущийВариантУдаления          = "Пометка";
	
	// Инициализируем динамический список на форме - имитация формы выбора.
	ОсновныеМетаданные = ЦелевойЭлемент.Метаданные();
	Список.ПроизвольныйЗапрос = Ложь;
	
	ПараметрыДинамическогоСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	ПараметрыДинамическогоСписка.ОсновнаяТаблица = ОсновныеМетаданные.ПолноеИмя();
	ПараметрыДинамическогоСписка.ДинамическоеСчитываниеДанных = Истина;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, ПараметрыДинамическогоСписка);
	
	Элементы.Список.ИзменятьПорядокСтрок = Ложь;
	Элементы.Список.ИзменятьСоставСтрок  = Ложь;
	
	СписокЗаменяемых = Новый СписокЗначений;
	СписокЗаменяемых.ЗагрузитьЗначения(ЗаменяемыеСсылки.Выгрузить().ВыгрузитьКолонку("Ссылка"));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Ссылка",
		СписокЗаменяемых,
		ВидСравненияКомпоновкиДанных.НеВСписке,
		НСтр("ru = 'Не показывать заменяемые'"),
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,
		"5bf5cd06-c1fd-4bd3-94b9-4e9803e90fd5");
	
	Если ОбщийВладелецЗаменяемыхСсылок <> Неопределено Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец", ОбщийВладелецЗаменяемыхСсылок );
	КонецЕсли;
	
	Если ЗаменяемыеСсылки.Количество() > 1 Тогда
		Элементы.НадписьТипВыбираемого.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выберите один из элементов ""%1"", на который следует заменить выбранные значения (%2):'"),
			ОсновныеМетаданные.Представление(), ЗаменяемыеСсылки.Количество());
	Иначе
		Заголовок = НСтр("ru = 'Замена элемента'");
		Элементы.НадписьТипВыбираемого.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выберите один из элементов ""%1"", на который следует заменить ""%2"":'"),
			ОсновныеМетаданные.Представление(), ЗаменяемыеСсылки[0].Ссылка);
	КонецЕсли;
	Элементы.ПодсказкаВыбораЦелевогоЭлемента.Заголовок = НСтр("ru = 'Элемент для замены не выбран.'");
	
	// Инициализация шагов пошагового мастера.
	ИнициализироватьНастройкиПошаговогоМастера();
	
	// 1. Выбор основного элемента.
	ШагВыбор = ДобавитьШагМастера(Элементы.ШагВыборЦелевогоЭлемента);
	ШагВыбор.КнопкаНазад.Видимость = Ложь;
	ШагВыбор.КнопкаДалее.Заголовок = НСтр("ru = 'Заменить >'");
	ШагВыбор.КнопкаДалее.Подсказка = НСтр("ru = 'Начать замену элементов'");
	ШагВыбор.КнопкаОтмена.Заголовок = НСтр("ru = 'Отмена'");
	ШагВыбор.КнопкаОтмена.Подсказка = НСтр("ru = 'Отказаться от замены элементов'");
	
	// 2. Ожидание процесса.
	Шаг = ДобавитьШагМастера(Элементы.ШагЗамена);
	Шаг.КнопкаОтмена.Видимость = Ложь;
	Шаг.КнопкаДалее.Видимость = Ложь;
	Шаг.КнопкаНазад.Заголовок = НСтр("ru = 'Прервать'");
	Шаг.КнопкаНазад.Подсказка = НСтр("ru = 'Вернуться к выбору основного элемента'");
	
	// 3. Проблемы замены ссылок.
	Шаг = ДобавитьШагМастера(Элементы.ШагПовторЗамены);
	Шаг.КнопкаНазад.Заголовок = НСтр("ru = '< Назад'");
	Шаг.КнопкаНазад.Подсказка = НСтр("ru = 'Вернутся к выбору целевого элемента'");
	Шаг.КнопкаДалее.Заголовок = НСтр("ru = 'Повторить замену >'");
	Шаг.КнопкаДалее.Подсказка = НСтр("ru = 'Повторить замену элементов'");
	Шаг.КнопкаОтмена.Заголовок = НСтр("ru = 'Закрыть'");
	Шаг.КнопкаОтмена.Подсказка = НСтр("ru = 'Закрыть результаты замены элементов'");
	
	// 4. Ошибки выполнения.
	Шаг = ДобавитьШагМастера(Элементы.ШагВозниклаОшибка);
	Шаг.КнопкаНазад.Видимость = Ложь;
	Шаг.КнопкаДалее.Видимость = Ложь;
	Шаг.КнопкаОтмена.Заголовок = НСтр("ru = 'Закрыть'");
	
	// Обновление элементов формы.
	НастройкиМастера.ТекущийШаг = ШагВыбор;
	ВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Необходимость сообщения об ошибке.
	Если Не ПустаяСтрока(ТекстОшибкиПараметров) Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, ТекстОшибкиПараметров);
		Возврат;
	КонецЕсли;
	
	// Запуск мастера.
	ПриАктивацииШагаМастера();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Элементы.ШагиМастера.ТекущаяСтраница <> Элементы.ШагЗамена
		Или Не НастройкиМастера.ПоказатьДиалогПередЗакрытием Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Прервать замену элементов и закрыть форму?'");
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(КодВозвратаДиалога.Прервать, НСтр("ru = 'Прервать'"));
	Кнопки.Добавить(КодВозвратаДиалога.Нет,      НСтр("ru = 'Не прерывать'"));
	
	Обработчик = Новый ОписаниеОповещения("ПослеПодтвержденияОтменыЗадания", ЭтотОбъект);
	ПоказатьВопрос(Обработчик, ТекстВопроса, Кнопки, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ЭЛЕМЕНТЫ

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодсказкаВыбораЦелевогоЭлементаОбработкаНавигационнойСсылки(Элемент, Ссылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Ссылка = "ПереключениеРежимаУдаления" Тогда
		Если ТекущийВариантУдаления = "Непосредственно" Тогда
			ТекущийВариантУдаления = "Пометка" 
		Иначе
			ТекущийВариантУдаления = "Непосредственно" 
		КонецЕсли;
		
		СформироватьЦелевойЭлементИПодсказку(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СсылкаПодробнееНажатие(Элемент)
	СтандартныеПодсистемыКлиент.ПоказатьПодробнуюИнформацию(Неопределено, Элемент.Подсказка);
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ТАБЛИЦА Список

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("СформироватьЦелевойЭлементИПодсказкуОтложенно", 0.01, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ШагВыборЦелевогоЭлементаПриНажатииКнопкиДалее();
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ТАБЛИЦА НеудачныеЗамены

#Область ОбработчикиСобытийЭлементовТаблицыФормыНеудачныеЗамены

&НаКлиенте
Процедура НеудачныеЗаменыПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		РасшифровкаПричиныНеудачи = "";
	Иначе
		РасшифровкаПричиныНеудачи = ТекущиеДанные.ПодробнаяПричина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НеудачныеЗаменыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Ссылка = НеудачныеЗамены.НайтиПоИдентификатору(ВыбраннаяСтрока).Ссылка;
	Если Ссылка <> Неопределено Тогда
		ПоказатьЗначение(, Ссылка);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// КОМАНДЫ

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбработчикКнопкиМастера(Команда)
	
	Если Команда.Имя = НастройкиМастера.КнопкаДалее Тогда
		
		ШагМастераДалее();
		
	ИначеЕсли Команда.Имя = НастройкиМастера.КнопкаНазад Тогда
		
		ШагМастераНазад();
		
	ИначеЕсли Команда.Имя = НастройкиМастера.КнопкаОтмена Тогда
		
		ШагМастераОтмена();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЭлементНеудачнойЗамены(Команда)
	ТекущиеДанные = Элементы.НеудачныеЗамены.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьВсеНеудачныеЗамены(Команда)
	ДеревоФормы = Элементы.НеудачныеЗамены;
	Для Каждого Элемент Из НеудачныеЗамены.ПолучитьЭлементы() Цикл
		ДеревоФормы.Развернуть(Элемент.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СвернутьВсеНеудачныеЗамены(Команда)
	ДеревоФормы = Элементы.НеудачныеЗамены;
	Для Каждого Элемент Из НеудачныеЗамены.ПолучитьЭлементы() Цикл
		ДеревоФормы.Свернуть(Элемент.ПолучитьИдентификатор());
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Программный интерфейс мастера

// Инициализирует структуры мастера.
// В реквизит формы НастройкиПошаговогоМастера записывается следующее значение:
//   Структура - Описание настроек мастера.
//     Общедоступные настройки мастера:
//       * Шаги - Массив - Описание шагов мастера. Только для чтения.
//           Для добавления шагов следует использовать функцию ДобавитьШагМастера.
//       * ТекущийШаг - Структура - Текущий шаг мастера. Только для чтения.
//       * ПоказатьДиалогПередЗакрытием - Булево - Если Истина, то перед закрытием формы будет показано предупреждение.
//           Для изменения.
//     Служебные настройки мастера:
//       * ГруппаСтраниц - Строка - Имя элемента формы, переданного в параметре ГруппаСтраниц.
//       * КнопкаДалее - Строка - Имя элемента формы, переданного в параметре КнопкаДалее.
//       * КнопкаНазад - Строка - Имя элемента формы, переданного в параметре КнопкаНазад.
//       * КнопкаОтмена - Строка - Имя элемента формы, переданного в параметре КнопкаОтмена.
//
&НаСервере
Процедура ИнициализироватьНастройкиПошаговогоМастера()
	НастройкиМастера = Новый Структура;
	НастройкиМастера.Вставить("Шаги", Новый Массив);
	НастройкиМастера.Вставить("ТекущийШаг", Неопределено);
	
	// Идентификаторы частей интерфейса.
	НастройкиМастера.Вставить("ГруппаСтраниц", Элементы.ШагиМастера.Имя);
	НастройкиМастера.Вставить("КнопкаДалее",   Элементы.ШагМастераДалее.Имя);
	НастройкиМастера.Вставить("КнопкаНазад",   Элементы.ШагМастераНазад.Имя);
	НастройкиМастера.Вставить("КнопкаОтмена",  Элементы.ШагМастераОтмена.Имя);
	
	// Для обработки длительных операций.
	НастройкиМастера.Вставить("ПоказатьДиалогПередЗакрытием", Ложь);
	
	// По умолчанию все отключено.
	Элементы.ШагМастераДалее.Видимость  = Ложь;
	Элементы.ШагМастераНазад.Видимость  = Ложь;
	Элементы.ШагМастераОтмена.Видимость = Ложь;
КонецПроцедуры

// Добавляет шаг мастера. Переходы между страницами будут происходить согласно порядку добавления.
//
// Параметры:
//   Страница - ГруппаФормы - Страница, содержащая элементы шага.
//
// Возвращаемое значение:
//   Структура - Описание настроек страницы.
//       * ИмяСтраницы - Строка - Имя страницы.
//       * КнопкаДалее - Структура - Описание кнопки "Далее".
//           ** Заголовок - Строка - Заголовок кнопки. По умолчанию: "Далее >".
//           ** Подсказка - Строка - Подсказка для кнопки. По умолчанию соответствует заголовку кнопки.
//           ** Видимость - Булево - Когда Истина то кнопка видна. По умолчанию: Истина.
//           ** Доступность - Булево - Когда Истина то кнопку можно нажимать. По умолчанию: Истина.
//           ** КнопкаПоУмолчанию - Булево - Когда Истина то кнопка будет основной кнопкой формы. По умолчанию: Истина.
//       * КнопкаНазад - Структура - Описание кнопки "Назад".
//           ** Заголовок - Строка - Заголовок кнопки. По умолчанию: "< Назад".
//           ** Подсказка - Строка - Подсказка для кнопки. По умолчанию соответствует заголовку кнопки.
//           ** Видимость - Булево - Когда Истина то кнопка видна. По умолчанию: Истина.
//           ** Доступность - Булево - Когда Истина то кнопку можно нажимать. По умолчанию: Истина.
//           ** КнопкаПоУмолчанию - Булево - Когда Истина то кнопка будет основной кнопкой формы. По умолчанию: Ложь.
//       * КнопкаОтмена - Структура - Описание кнопки "Отмена".
//           ** Заголовок - Строка - Заголовок кнопки. По умолчанию: "Отмена".
//           ** Подсказка - Строка - Подсказка для кнопки. По умолчанию соответствует заголовку кнопки.
//           ** Видимость - Булево - Когда Истина то кнопка видна. По умолчанию: Истина.
//           ** Доступность - Булево - Когда Истина то кнопку можно нажимать. По умолчанию: Истина.
//           ** КнопкаПоУмолчанию - Булево - Когда Истина то кнопка будет основной кнопкой формы. По умолчанию: Ложь.
//
&НаСервере
Функция ДобавитьШагМастера(Знач Страница)
	ОписаниеШага = Новый Структура("Индекс, ИмяСтраницы, КнопкаНазад, КнопкаДалее, КнопкаОтмена");
	ОписаниеШага.ИмяСтраницы = Страница.Имя;
	ОписаниеШага.КнопкаНазад = КнопкаМастера();
	ОписаниеШага.КнопкаНазад.Заголовок = НСтр("ru = '< Назад'");
	ОписаниеШага.КнопкаДалее = КнопкаМастера();
	ОписаниеШага.КнопкаДалее.КнопкаПоУмолчанию = Истина;
	ОписаниеШага.КнопкаДалее.Заголовок = НСтр("ru = 'Далее >'");
	ОписаниеШага.КнопкаОтмена = КнопкаМастера();
	ОписаниеШага.КнопкаОтмена.Заголовок = НСтр("ru = 'Отмена'");
	
	НастройкиМастера.Шаги.Добавить(ОписаниеШага);
	
	ОписаниеШага.Индекс = НастройкиМастера.Шаги.ВГраница();
	Возврат ОписаниеШага;
КонецФункции

// Обновляет видимость и доступность элементов формы в соответствии с текущим шагом мастера.
&НаКлиентеНаСервереБезКонтекста
Процедура ВидимостьДоступность(Форма)
	
	Элементы = Форма.Элементы;
	НастройкиМастера = Форма.НастройкиМастера;
	ТекущийШаг = НастройкиМастера.ТекущийШаг;
	
	// Переключение страницы.
	Элементы[НастройкиМастера.ГруппаСтраниц].ТекущаяСтраница = Элементы[ТекущийШаг.ИмяСтраницы];
	
	// Обновление кнопок.
	ОбновитьСвойстваКнопкиМастера(Элементы[НастройкиМастера.КнопкаДалее],  ТекущийШаг.КнопкаДалее);
	ОбновитьСвойстваКнопкиМастера(Элементы[НастройкиМастера.КнопкаНазад],  ТекущийШаг.КнопкаНазад);
	ОбновитьСвойстваКнопкиМастера(Элементы[НастройкиМастера.КнопкаОтмена], ТекущийШаг.КнопкаОтмена);
	
КонецПроцедуры

// Выполняет переход мастера на указанную страницу.
//
// Параметры:
//   ШагИлиИндексИлиГруппаФормы - Структура, Число, ГруппаФормы - Страницу, на которую необходимо перейти.
//
&НаКлиенте
Процедура ПерейтиНаШагМастера(Знач ШагИлиИндексИлиГруппаФормы)
	
	// Поиск шага.
	Тип = ТипЗнч(ШагИлиИндексИлиГруппаФормы);
	Если Тип = Тип("Структура") Тогда
		ОписаниеШага = ШагИлиИндексИлиГруппаФормы;
	ИначеЕсли Тип = Тип("Число") Тогда
		ИндексШага = ШагИлиИндексИлиГруппаФормы;
		Если ИндексШага < 0 Тогда
			ВызватьИсключение НСтр("ru = 'Попытка выхода назад из первого шага мастера'");
		ИначеЕсли ИндексШага > НастройкиМастера.Шаги.ВГраница() Тогда
			ВызватьИсключение НСтр("ru = 'Попытка выхода за последний шаг мастера'");
		КонецЕсли;
		ОписаниеШага = НастройкиМастера.Шаги[ИндексШага];
	Иначе
		ШагНайден = Ложь;
		ИмяИскомойСтраницы = ШагИлиИндексИлиГруппаФормы.Имя;
		Для Каждого ОписаниеШага Из НастройкиМастера.Шаги Цикл
			Если ОписаниеШага.ИмяСтраницы = ИмяИскомойСтраницы Тогда
				ШагНайден = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Не ШагНайден Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не найден шаг ""%1"".'"),
				ИмяИскомойСтраницы);
		КонецЕсли;
	КонецЕсли;
	
	// Переключение шага.
	НастройкиМастера.ТекущийШаг = ОписаниеШага;
	
	// Обновление видимости.
	ВидимостьДоступность(ЭтотОбъект);
	ПриАктивацииШагаМастера();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// События мастера

&НаКлиенте
Процедура ПриАктивацииШагаМастера()
	
	ТекущаяСтраница = Элементы.ШагиМастера.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.ШагВыборЦелевогоЭлемента Тогда
		
		СформироватьЦелевойЭлементИПодсказку(ЭтотОбъект);
		
	ИначеЕсли ТекущаяСтраница = Элементы.ШагЗамена Тогда
		
		НастройкиМастера.ПоказатьДиалогПередЗакрытием = Истина;
		ЦелевойЭлементРезультат = ЦелевойЭлемент; // Сохранение параметров запуска.
		ЗапуститьФоновоеЗаданиеКлиент();
		
	ИначеЕсли ТекущаяСтраница = Элементы.ШагПовторЗамены Тогда
		
		// Обновление количества неудач.
		Неудачные = Новый Соответствие;
		Для Каждого Строка Из НеудачныеЗамены.ПолучитьЭлементы() Цикл
			Неудачные.Вставить(Строка.Ссылка, Истина);
		КонецЦикла;
		
		КоличествоЗамен = ЗаменяемыеСсылки.Количество();
		Элементы.РезультатНеудачныеЗамены.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось заменить элементы (%1 из %2). В некоторых местах использования не может быть произведена
			           |автоматическая замена на ""%3""'"),
			Неудачные.Количество(),
			КоличествоЗамен,
			ЦелевойЭлемент);
		
		// Формирование списка успешных замен и чистка списка заменяемых.
		СписокОбновленного = Новый Массив;
		СписокОбновленного.Добавить(ЦелевойЭлемент);
		Для Номер = 1 По КоличествоЗамен Цикл
			ОбратныйИндекс = КоличествоЗамен - Номер;
			Ссылка = ЗаменяемыеСсылки[ОбратныйИндекс].Ссылка;
			Если Ссылка <> ЦелевойЭлемент И Неудачные[Ссылка] = Неопределено Тогда
				ЗаменяемыеСсылки.Удалить(ОбратныйИндекс);
				СписокОбновленного.Добавить(Ссылка);
			КонецЕсли;
		КонецЦикла;
		
		// Оповещение о выполненных заменах.
		ОповеститьОбУспешнойЗамене(СписокОбновленного);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ШагМастераДалее()
	
	ТекущаяСтраница = Элементы.ШагиМастера.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.ШагВыборЦелевогоЭлемента Тогда
		
		ШагВыборЦелевогоЭлементаПриНажатииКнопкиДалее();
		
	ИначеЕсли ТекущаяСтраница = Элементы.ШагПовторЗамены Тогда
		
		ПерейтиНаШагМастера(Элементы.ШагЗамена);
		
	Иначе
		
		ПерейтиНаШагМастера(НастройкиМастера.ТекущийШаг.Индекс + 1);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ШагМастераНазад()
	
	ТекущаяСтраница = Элементы.ШагиМастера.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.ШагПовторЗамены Тогда
		
		ПерейтиНаШагМастера(Элементы.ШагВыборЦелевогоЭлемента);
		
	Иначе
		
		ПерейтиНаШагМастера(НастройкиМастера.ТекущийШаг.Индекс - 1);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ШагМастераОтмена()
	
	ТекущаяСтраница = Элементы.ШагиМастера.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.ШагЗамена Тогда
		
		НастройкиМастера.ПоказатьДиалогПередЗакрытием = Ложь;
		
	КонецЕсли;
	
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Служебные процедуры замены и объединения элементов

&НаКлиенте
Процедура ШагВыборЦелевогоЭлементаПриНажатииКнопкиДалее()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли ЗаменяемыеСсылки.Количество() = 1 И ТекущиеДанные.Ссылка = ЗаменяемыеСсылки.Получить(0).Ссылка Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя заменять элемент сам на себя.'"));
		Возврат;
	ИначеЕсли ЗначениеРеквизита(ТекущиеДанные, "ЭтоГруппа", Ложь) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя заменять элемент на группу.'"));
		Возврат;
	КонецЕсли;
	
	ТекущийВладелец = ЗначениеРеквизита(ТекущиеДанные, "Владелец");
	Если ТекущийВладелец <> ОбщийВладелецЗаменяемыхСсылок Тогда
		Текст = НСтр("ru = 'Нельзя заменять на элемент, подчиненный другому владельцу.
			|У выбранного элемента владелец ""%1"", а у заменяемого - ""%2"".'");
		ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, ТекущийВладелец, ОбщийВладелецЗаменяемыхСсылок));
		Возврат;
	КонецЕсли;
	
	Если ЗначениеРеквизита(ТекущиеДанные, "ПометкаУдаления", Ложь) Тогда
		// Попытка заменить на элемент, помеченный на удаление.
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Элемент %1 помечен на удаление. Продолжить?'"),
			ТекущиеДанные.Ссылка);
		Описание = Новый ОписаниеОповещения("ПодтверждениеВыбораЦелевогоЭлемента", ЭтотОбъект);
		ПоказатьВопрос(Описание, Текст, РежимДиалогаВопрос.ДаНет);
	Иначе
		// Нужна дополнительная проверка по прикладным данным.
		ПроверкаДопустимостиЗаменыПрикладнойОбласти();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОбУспешнойЗамене(Знач СписокДанных)
	// Изменения объектов, в которых происходили замены.
	СписокТипов = Новый Соответствие;
	Для Каждого Элемент Из СписокДанных Цикл
		Тип = ТипЗнч(Элемент);
		Если СписокТипов[Тип] = Неопределено Тогда
			ОповеститьОбИзменении(Тип);
			СписокТипов.Вставить(Тип, Истина);
		КонецЕсли;
	КонецЦикла;
	
	// Общее оповещение
	Если СписокТипов.Количество()>0 Тогда
		Оповестить(СобытиеОповещенияОЗамене, , ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЦелевойЭлементИПодсказкуОтложенно()
	СформироватьЦелевойЭлементИПодсказку(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждениеВыбораЦелевогоЭлемента(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	// Дополнительная проверка по прикладным данным.
	ПроверкаДопустимостиЗаменыПрикладнойОбласти();
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаДопустимостиЗаменыПрикладнойОбласти()
	// Проверка допустимости замен с прикладной точки зрения.
	ТекстОшибки = ПроверитьВозможностьЗаменыСсылок();
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		НастройкиДиалога = Новый Структура;
		НастройкиДиалога.Вставить("ПредлагатьБольшеНеЗадаватьЭтотВопрос", Ложь);
		НастройкиДиалога.Вставить("Картинка", БиблиотекаКартинок.Предупреждение32);
		НастройкиДиалога.Вставить("КнопкаПоУмолчанию", 0);
		НастройкиДиалога.Вставить("Заголовок", НСтр("ru = 'Невозможно заменить элементы'"));
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(0, НСтр("ru = 'ОК'"));
		
		СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(Неопределено, ТекстОшибки, Кнопки, НастройкиДиалога);
		Возврат;
	КонецЕсли;
	
	ПерейтиНаШагМастера(НастройкиМастера.ТекущийШаг.Индекс + 1);
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЦелевойЭлементИПодсказку(Контекст)
	
	ТекущиеДанные = Контекст.Элементы.Список.ТекущиеДанные;
	// Обходим пустоту и группы
	Если ТекущиеДанные = Неопределено Или ЗначениеРеквизита(ТекущиеДанные, "ЭтоГруппа", Ложь) Тогда
		Возврат;
	КонецЕсли;
	Контекст.ЦелевойЭлемент = ТекущиеДанные.Ссылка;
	
	Количество = Контекст.ЗаменяемыеСсылки.Количество();
	Если Количество = 1 Тогда
		
		Если Контекст.ЕстьПравоБезвозвратногоУдаления Тогда
			Если Контекст.ТекущийВариантУдаления = "Пометка" Тогда
				ТекстПодсказки = НСтр("ru = 'Выбранный элемент будет заменен на ""%1""
					|и <a href = ""ПереключениеРежимаУдаления"">помечен на удаление</a>.'");
			Иначе
				ТекстПодсказки = НСтр("ru = 'Выбранный элемент будет заменен на ""%1""
					|и <a href = ""ПереключениеРежимаУдаления"">удален безвозвратно</a>.'");
			КонецЕсли;
		Иначе
			ТекстПодсказки = НСтр("ru = 'Выбранный элемент будет заменен на ""%1""
				|и помечен на удаление.'");
		КонецЕсли;
		
		ТекстПодсказки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПодсказки, Контекст.ЦелевойЭлемент);
		Контекст.Элементы.ПодсказкаВыбораЦелевогоЭлемента.Заголовок = СтроковыеФункцииКлиент.ФорматированнаяСтрока(ТекстПодсказки);
		
	Иначе
		
		Если Контекст.ЕстьПравоБезвозвратногоУдаления Тогда
			Если Контекст.ТекущийВариантУдаления = "Пометка" Тогда
				ТекстПодсказки = НСтр("ru = 'Выбранные элементы (%1) будут заменены на ""%2""
					|и <a href = ""ПереключениеРежимаУдаления"">помечены на удаление</a>.'");
			Иначе
				ТекстПодсказки = НСтр("ru = 'Выбранные элементы (%1) будут заменены на ""%2""
					|и <a href = ""ПереключениеРежимаУдаления"">удалены безвозвратно</a>.'");
			КонецЕсли;
		Иначе
			ТекстПодсказки = НСтр("ru = 'Выбранные элементы (%1) будут заменены на ""%2""
				|и помечен на удаление.'");
		КонецЕсли;
			
		ТекстПодсказки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПодсказки, Количество, Контекст.ЦелевойЭлемент);
		Контекст.Элементы.ПодсказкаВыбораЦелевогоЭлемента.Заголовок = СтроковыеФункцииКлиент.ФорматированнаяСтрока(ТекстПодсказки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеРеквизита(Знач Данные, Знач ИмяРеквизита, Знач ЗначениеПриОтсутствии = Неопределено)
	// Безопасное получение значения реквизита.
	Проба = Новый Структура(ИмяРеквизита);
	
	ЗаполнитьЗначенияСвойств(Проба, Данные);
	Если Проба[ИмяРеквизита] <> Неопределено Тогда
		// Есть значение
		Возврат Проба[ИмяРеквизита];
	КонецЕсли;
	
	// Возможно значение в данных равно Неопределено.
	Проба[ИмяРеквизита] = Истина;
	ЗаполнитьЗначенияСвойств(Проба, Данные);
	Если Проба[ИмяРеквизита] <> Истина Тогда
		Возврат Проба[ИмяРеквизита];
	КонецЕсли;
	
	Возврат ЗначениеПриОтсутствии;
КонецФункции

&НаСервере
Функция ПроверитьВозможностьЗаменыСсылок()
	
	ПарыЗамен = Новый Соответствие;
	Для Каждого Строка Из ЗаменяемыеСсылки Цикл
		ПарыЗамен.Вставить(Строка.Ссылка, ЦелевойЭлемент);
	КонецЦикла;
	
	ПараметрыЗамены = Новый Структура("СпособУдаления", ТекущийВариантУдаления);
	Возврат ПоискИУдалениеДублей.ПроверитьВозможностьЗаменыЭлементовСтрока(ПарыЗамен, ПараметрыЗамены);
	
КонецФункции

&НаСервереБезКонтекста
Функция МассивСсылокИзСписка(Знач Ссылки)
	// Преобразует массив, список значений или коллекцию в массив.
	
	ТипПараметра = ТипЗнч(Ссылки);
	Если Ссылки = Неопределено Тогда
		МассивСсылок = Новый Массив;
		
	ИначеЕсли ТипПараметра  = Тип("СписокЗначений") Тогда
		МассивСсылок = Ссылки.ВыгрузитьЗначения();
		
	ИначеЕсли ТипПараметра = Тип("Массив") Тогда
		МассивСсылок = Ссылки;
		
	Иначе
		МассивСсылок = Новый Массив;
		Для Каждого Элемент Из Ссылки Цикл
			МассивСсылок.Добавить(Элемент.Ссылка);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат МассивСсылок;
КонецФункции

&НаСервереБезКонтекста
Функция ВозможныйКодСсылки(Знач Ссылка, КэшМетаданных)
	// Возвращаемое значение:
	//     Произвольный - код справочника и т.п. если он есть по метаданным, 
	//     Неопределено - если кода нет.
	Мета = Ссылка.Метаданные();
	ЕстьКод = КэшМетаданных[Мета];
	
	Если ЕстьКод = Неопределено Тогда
		// Проверяем, если ли код вообще.
		Тест = Новый Структура("ДлинаКода", 0);
		ЗаполнитьЗначенияСвойств(Тест, Мета);
		ЕстьКод = Тест.ДлинаКода > 0;
		
		КэшМетаданных[Мета] = ЕстьКод;
	КонецЕсли;
	
	Возврат ?(ЕстьКод, Ссылка.Код, Неопределено);
КонецФункции

&НаСервере
Процедура ИнициализироватьЗаменяемыеСсылки(Знач МассивСсылок)
	
	КоличествоСсылок = МассивСсылок.Количество();
	Если КоличествоСсылок = 0 Тогда
		ТекстОшибкиПараметров = НСтр("ru = 'Не указано ни одного элемента для замены.'");
		Возврат;
	КонецЕсли;
	
	ЦелевойЭлемент = МассивСсылок[0];
	
	ОсновныеМетаданные = ЦелевойЭлемент.Метаданные();
	Характеристики = Новый Структура("Владельцы, Иерархический, ВидИерархии", Новый Массив, Ложь);
	ЗаполнитьЗначенияСвойств(Характеристики, ОсновныеМетаданные);
	
	ЕстьВладельцы = Характеристики.Владельцы.Количество() > 0;
	ЕстьГруппы    = Характеристики.Иерархический И Характеристики.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов;
	
	ДополнительныеПоля = "";
	Если ЕстьВладельцы Тогда
		ДополнительныеПоля = ДополнительныеПоля + ", Владелец КАК Владелец";
	Иначе
		ДополнительныеПоля = ДополнительныеПоля + ", НЕОПРЕДЕЛЕНО КАК Владелец";
	КонецЕсли;
	
	Если ЕстьГруппы Тогда
		ДополнительныеПоля = ДополнительныеПоля + ", ЭтоГруппа КАК ЭтоГруппа";
	Иначе
		ДополнительныеПоля = ДополнительныеПоля + ", ЛОЖЬ КАК ЭтоГруппа";
	КонецЕсли;
	
	ИмяТаблицы = ОсновныеМетаданные.ПолноеИмя();
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|Ссылка КАК Ссылка
		|" + ДополнительныеПоля + "
		|ПОМЕСТИТЬ ЗаменяемыеСсылки
		|ИЗ
		|	" + ИмяТаблицы + "
		|ГДЕ
		|	Ссылка В (&НаборСсылок)
		|ИНДЕКСИРОВАТЬ ПО
		|	Владелец,
		|	ЭтоГруппа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Владелец) КАК КоличествоВладельцев,
		|	МИНИМУМ(Владелец)              КАК ОбщийВладелец,
		|	МАКСИМУМ(ЭтоГруппа)            КАК ЕстьГруппы,
		|	КОЛИЧЕСТВО(Ссылка)             КАК КоличествоСсылок
		|ИЗ
		|	ЗаменяемыеСсылки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ЦелеваяТаблица.Ссылка
		|ИЗ
		|	" + ИмяТаблицы + " КАК ЦелеваяТаблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ ЗаменяемыеСсылки КАК ЗаменяемыеСсылки
		|		ПО ЦелеваяТаблица.Ссылка = ЗаменяемыеСсылки.Ссылка
		|		И ЦелеваяТаблица.Владелец = ЗаменяемыеСсылки.Владелец
		|ГДЕ
		|	ЗаменяемыеСсылки.Ссылка ЕСТЬ NULL
		|	И НЕ ЦелеваяТаблица.ЭтоГруппа");
		
	Если Не ЕстьВладельцы Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ЦелеваяТаблица.Владелец = ЗаменяемыеСсылки.Владелец", "");
	КонецЕсли;
	Если Не ЕстьГруппы Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И НЕ ЦелеваяТаблица.ЭтоГруппа", "");
	КонецЕсли;
	Запрос.УстановитьПараметр("НаборСсылок", МассивСсылок);
	
	Результат = Запрос.ВыполнитьПакет();
	Условия = Результат[1].Выгрузить()[0];
	Если Условия.ЕстьГруппы Тогда
		ТекстОшибкиПараметров = НСтр("ru = 'Один из заменяемых элементов является группой.
		                                   |Группы не могут быть заменены.'");
		Возврат;
	ИначеЕсли Условия.КоличествоВладельцев > 1 Тогда 
		ТекстОшибкиПараметров = НСтр("ru = 'У заменяемых элементов разные владельцы.
		                                   |Такие элементы не могут быть заменены.'");
		Возврат;
	ИначеЕсли Условия.КоличествоСсылок <> КоличествоСсылок Тогда
		ТекстОшибкиПараметров = НСтр("ru = 'Все заменяемые элементы должны быть одного типа.'");
		Возврат;
	КонецЕсли;
	
	Если Результат[2].Выгрузить().Количество() = 0 Тогда
		Если КоличествоСсылок > 1 Тогда
			ТекстОшибкиПараметров = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Выбранные элементы (%1) не на что заменить.'"), КоличествоСсылок);
		Иначе
			ТекстОшибкиПараметров = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Выбранный элемент ""%1"" не на что заменить.'"), ОбщегоНазначения.ПредметСтрокой(ЦелевойЭлемент));
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ОбщийВладелецЗаменяемыхСсылок = ?(ЕстьВладельцы, Условия.ОбщийВладелец, Неопределено);
	Для Каждого Элемент Из МассивСсылок Цикл
		ЗаменяемыеСсылки.Добавить().Ссылка = Элемент;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с длительными операциями

&НаКлиенте
Процедура ЗапуститьФоновоеЗаданиеКлиент()
	
	ПараметрыМетода = Новый Структура("ПарыЗамен, СпособУдаления");
	ПараметрыМетода.ПарыЗамен = Новый Соответствие;
	Для Каждого Строка Из ЗаменяемыеСсылки Цикл
		ПараметрыМетода.ПарыЗамен.Вставить(Строка.Ссылка, ЦелевойЭлемент);
	КонецЦикла;
	ПараметрыМетода.Вставить("СпособУдаления", ТекущийВариантУдаления);
	
	Задание = ЗапуститьФоновоеЗадание(ПараметрыМетода, УникальныйИдентификатор);
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
	
	Обработчик = Новый ОписаниеОповещения("ПослеЗавершенияФоновогоЗадания", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, Обработчик, НастройкиОжидания);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапуститьФоновоеЗадание(Знач ПараметрыМетода, Знач УникальныйИдентификатор)
	
	ИмяМетода = "ПоискИУдалениеДублей.ЗаменитьСсылки";
	НаименованиеМетода = НСтр("ru = 'Поиск и удаление дублей: Замена ссылок'");
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = НаименованиеМетода;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыМетода, НастройкиЗапуска);
	
КонецФункции

&НаКлиенте
Процедура ПослеЗавершенияФоновогоЗадания(Задание, ДополнительныеПараметры) Экспорт
	
	НастройкиМастера.ПоказатьДиалогПередЗакрытием = Ложь;
	Если Задание = Неопределено 
		ИЛИ Элементы.ШагиМастера.ТекущаяСтраница = Элементы.ШагВыборЦелевогоЭлемента Тогда
		Возврат;
	КонецЕсли;
	
	Если Задание.Статус <> "Выполнено" Тогда
		// Фоновое задание завершено с ошибкой.
		Кратко = НСтр("ru = 'При замене элементов возникла ошибка:'") + Символы.ПС + Задание.КраткоеПредставлениеОшибки;
		Подробно = Кратко + Символы.ПС + Символы.ПС + Задание.ПодробноеПредставлениеОшибки;
		Элементы.НадписьТекстОшибки.Заголовок = Кратко;
		Элементы.СсылкаПодробнее.Подсказка    = Подробно;
		ПерейтиНаШагМастера(Элементы.ШагВозниклаОшибка);
		Активизировать();
		Возврат;
	КонецЕсли;
	
	ЕстьНеудачныеЗамены = ЗаполнитьНеудачныеЗамены(Задание.АдресРезультата);
	Если ЕстьНеудачныеЗамены Тогда
		// Частично успешно - вывести расшифровку.
		ПерейтиНаШагМастера(Элементы.ШагПовторЗамены);
		Активизировать();
	Иначе
		// Полностью успешно - вывести оповещение и закрыть форму.
		Количество = ЗаменяемыеСсылки.Количество();
		Если Количество = 1 Тогда
			ТекстРезультата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Элемент ""%1"" заменен на ""%2""'"),
				ЗаменяемыеСсылки[0].Ссылка,
				ЦелевойЭлементРезультат);
		Иначе
			ТекстРезультата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Элементы (%1) заменены на ""%2""'"),
				Количество,
				ЦелевойЭлементРезультат);
		КонецЕсли;
		ПоказатьОповещениеПользователя(
			,
			ПолучитьНавигационнуюСсылку(ЦелевойЭлемент),
			ТекстРезультата,
			БиблиотекаКартинок.Информация32);
		СписокОбновленного = Новый Массив;
		Для Каждого Строка Из ЗаменяемыеСсылки Цикл
			СписокОбновленного.Добавить(Строка.Ссылка);
		КонецЦикла;
		ОповеститьОбУспешнойЗамене(СписокОбновленного);
		Закрыть();
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьНеудачныеЗамены(Знач АдресРезультата)
	// РезультатыЗамены - таблица с колонками Ссылка, ОбъектОшибки, ТипОшибки, ТекстОшибки.
	РезультатыЗамены = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	КорневыеСтроки = НеудачныеЗамены.ПолучитьЭлементы();
	КорневыеСтроки.Очистить();
	
	СоответствиеСтрок = Новый Соответствие;
	КэшМетаданных     = Новый Соответствие;
	
	Для Каждого СтрокаРезультата Из РезультатыЗамены Цикл
		Ссылка = СтрокаРезультата.Ссылка;
		
		ОшибкиПоСсылке = СоответствиеСтрок[Ссылка];
		Если ОшибкиПоСсылке = Неопределено Тогда
			СтрокаДерева = КорневыеСтроки.Добавить();
			СтрокаДерева.Ссылка = Ссылка;
			СтрокаДерева.Данные = Строка(Ссылка);
			СтрокаДерева.Код    = Строка( ВозможныйКодСсылки(Ссылка, КэшМетаданных) );
			СтрокаДерева.Пиктограмма = -1;
			
			ОшибкиПоСсылке = СтрокаДерева.ПолучитьЭлементы();
			СоответствиеСтрок.Вставить(Ссылка, ОшибкиПоСсылке);
		КонецЕсли;
		
		СтрокаОшибки = ОшибкиПоСсылке.Добавить();
		СтрокаОшибки.Ссылка = СтрокаРезультата.ОбъектОшибки;
		СтрокаОшибки.Данные = СтрокаРезультата.ПредставлениеОбъектаОшибки;
		
		ТипОшибки = СтрокаРезультата.ТипОшибки;
		Если ТипОшибки = "НеизвестныеДанные" Тогда
			СтрокаОшибки.Причина = НСтр("ru = 'Обнаружена данные, обработка которых не планировалась.'");
			
		ИначеЕсли ТипОшибки = "ОшибкаБлокировки" Тогда
			СтрокаОшибки.Причина = НСтр("ru = 'Не удалось заблокировать данные.'");
			
		ИначеЕсли ТипОшибки = "ДанныеИзменены" Тогда
			СтрокаОшибки.Причина = НСтр("ru = 'Данные изменены другим пользователем.'");
			
		ИначеЕсли ТипОшибки = "ОшибкаЗаписи" Тогда
			СтрокаОшибки.Причина = СтрокаРезультата.ТекстОшибки;
			
		ИначеЕсли ТипОшибки = "ОшибкаУдаления" Тогда
			СтрокаОшибки.Причина = НСтр("ru = 'Невозможно удалить данные.'");
			
		Иначе
			СтрокаОшибки.Причина = НСтр("ru = 'Неизвестная ошибка.'");
			
		КонецЕсли;
		
		СтрокаОшибки.ПодробнаяПричина = СтрокаРезультата.ТекстОшибки;
	КонецЦикла; // результаты замены
	
	Возврат КорневыеСтроки.Количество() > 0;
КонецФункции

&НаКлиенте
Процедура ПослеПодтвержденияОтменыЗадания(Ответ, ПараметрыВыполнения) Экспорт
	Если Ответ = КодВозвратаДиалога.Прервать
		И Элементы.ШагиМастера.ТекущаяСтраница = Элементы.ШагЗамена Тогда
		НастройкиМастера.ПоказатьДиалогПередЗакрытием = Ложь;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Служебные процедуры и функции мастера

&НаКлиентеНаСервереБезКонтекста
Функция КнопкаМастера()
	// Описание настроек кнопки мастера.
	//
	// Возвращаемое значение:
	//   Структура - Настройки кнопки формы.
	//       * Заголовок         - Строка - Заголовок кнопки.
	//       * Подсказка         - Строка - Подсказка для кнопки.
	//       * Видимость         - Булево - Когда Истина то кнопка видна. Значение по умолчанию: Истина.
	//       * Доступность       - Булево - Когда Истина то кнопку можно нажимать. Значение по умолчанию: Истина.
	//       * КнопкаПоУмолчанию - Булево - Когда Истина то кнопка будет основной кнопкой формы. Значение по умолчанию:
	//                                      Ложь.
	//
	// См. также:
	//   "КнопкаФормы" в синтакс-помощнике.
	//
	Результат = Новый Структура;
	Результат.Вставить("Заголовок", "");
	Результат.Вставить("Подсказка", "");
	
	Результат.Вставить("Доступность", Истина);
	Результат.Вставить("Видимость", Истина);
	Результат.Вставить("КнопкаПоУмолчанию", Ложь);
	
	Возврат Результат;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСвойстваКнопкиМастера(КнопкаМастера, Описание)
	
	ЗаполнитьЗначенияСвойств(КнопкаМастера, Описание);
	КнопкаМастера.РасширеннаяПодсказка.Заголовок = Описание.Подсказка;
	
КонецПроцедуры

#КонецОбласти