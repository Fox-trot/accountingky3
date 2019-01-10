﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СообщениеВопрос = Параметры.СообщениеВопрос;
	СообщениеЗаголовок = Параметры.СообщениеЗаголовок;
	Заголовок = Параметры.Заголовок;
	
	НастроитьДинамическийСписок();
	
	Список.Параметры.УстановитьЗначениеПараметра("Редактирует", Параметры.Редактирует);
	Если ЗначениеЗаполнено(Параметры.ВладелецФайла) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ВладелецФайла", Параметры.ВладелецФайла);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Параметры.ЗаголовокКнопкиДа) Тогда 
		Элементы.Да.Заголовок = Параметры.ЗаголовокКнопкиДа;
	КонецЕсли;
	
	Если Не ПустаяСтрока(Параметры.ЗаголовокКнопкиНет) Тогда 
		Элементы.Нет.Заголовок = Параметры.ЗаголовокКнопкиНет;
	КонецЕсли;
	
	Если Параметры.ЗавершениеРаботыПрограммы Тогда 
		Ответ = Параметры.ЗавершениеРаботыПрограммы;
		Если Ответ = Истина Тогда
			Элементы.ПоказыватьЗанятыеФайлыПриЗавершенииРаботы.Видимость = Ответ;
			РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
		КонецЕсли;
	КонецЕсли;
	
	ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ПоказыватьЗанятыеФайлыПриЗавершенииРаботы", Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" Тогда
		Элементы.Список.Обновить(); 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Список.ТекущиеДанные.Ссылка, Неопределено, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.ОткрытьФайлСОповещением(Неопределено, ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПрисоединенныйФайл", ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныйФайл", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ТекущиеДанные.Ссылка, Неопределено, УникальныйИдентификатор);
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ТекущиеДанные.Ссылка, Неопределено, УникальныйИдентификатор);
	РаботаСФайламиКлиент.ОткрытьКаталогФайла(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаИРабочийКаталог(ТекущиеДанные.Ссылка);
	РаботаСФайламиСлужебныйКлиент.ОбновитьИзФайлаНаДискеСОповещением(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыОсвобожденияФайла = РаботаСФайламиСлужебныйКлиент.ПараметрыОсвобожденияФайла(Неопределено, ТекущиеДанные.Ссылка);
	ПараметрыОсвобожденияФайла.ХранитьВерсии = ТекущиеДанные.ХранитьВерсии;
	ПараметрыОсвобожденияФайла.ФайлРедактируетТекущийПользователь = Истина;
	ПараметрыОсвобожденияФайла.Редактирует = ТекущиеДанные.Редактирует;
	РаботаСФайламиСлужебныйКлиент.ОсвободитьФайлСОповещением(ПараметрыОсвобожденияФайла);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиСлужебныйКлиент.СохранитьИзмененияФайлаСОповещением(
		Неопределено,
		ТекущиеДанные.Ссылка,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляСохранения(
		ТекущиеДанные.Ссылка, , УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.СохранитьКак(Неопределено, ДанныеФайла, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	МассивСтруктур = Новый Массив;
	
	МассивСтруктур.Добавить(ОписаниеНастройки(
		"НастройкиПрограммы",
		"ПоказыватьЗанятыеФайлыПриЗавершенииРаботы",
		ПоказыватьЗанятыеФайлыПриЗавершенииРаботы));
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	
	Закрыть(КодВозвратаДиалога.Да);
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыОбновленияФайла = РаботаСФайламиСлужебныйКлиент.ПараметрыОбновленияФайла(
		Неопределено, СтрокаТаблицы.Ссылка, УникальныйИдентификатор);
	ПараметрыОбновленияФайла.ХранитьВерсии = СтрокаТаблицы.ХранитьВерсии;
	ПараметрыОбновленияФайла.ФайлРедактируетТекущийПользователь = Истина;
	ПараметрыОбновленияФайла.Редактирует = СтрокаТаблицы.Редактирует;
	РаботаСФайламиСлужебныйКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСвойстваФайла(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПрисоединенныйФайл", ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныйФайл", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ОписаниеНастройки(Объект, Настойка, Значение)
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", Объект);
	Элемент.Вставить("Настройка", Настойка);
	Элемент.Вставить("Значение", Значение);
	
	Возврат Элемент;
	
КонецФункции

&НаСервере
Процедура НастроитьДинамическийСписок()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ТИПЗНАЧЕНИЯ(СведенияОФайлах.Файл) КАК ТипФайла
		|ИЗ
		|	РегистрСведений.СведенияОФайлах КАК СведенияОФайлах
		|ГДЕ
		|	СведенияОФайлах.Редактирует = &Редактирует";
		
	Запрос.УстановитьПараметр("Редактирует", Параметры.Редактирует);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	МассивТипов      = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ТипФайла");
	УстановитьПривилегированныйРежим(Ложь);
	
	ТекстЗапроса = "";
	Для Каждого ТипСправочника Из МассивТипов Цикл
		МетаданныеСправочника = Метаданные.НайтиПоТипу(ТипСправочника);
		
		Если Не ПравоДоступа("Изменение", МетаданныеСправочника) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не СтрЗаканчиваетсяНа(МетаданныеСправочника.Имя, "ВерсииПрисоединенныхФайлов") И МетаданныеСправочника.Имя <> "ВерсииФайлов" Тогда
			
			Если Не ПустаяСтрока(ТекстЗапроса) Тогда
				ТекстЗапроса = ТекстЗапроса + "
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|	ВЫБРАТЬ";
			Иначе
				ТекстЗапроса = ТекстЗапроса + "
				|	ВЫБРАТЬ РАЗРЕШЕННЫЕ";
			КонецЕсли;
			
			ТекстЗапроса = ТекстЗапроса + "
			|	Файлы.Редактирует,
			|	Файлы.ИндексКартинки,
			|	Файлы.Наименование,
			|	Файлы.Описание,
			|	Файлы.Ссылка,
			|	Файлы.ХранитьВерсии,
			|	Файлы.ВладелецФайла,
			|	Файлы.Размер / 1024,
			|	Файлы.Автор
			|ИЗ
			|	" + МетаданныеСправочника.ПолноеИмя() + " КАК Файлы
			|ГДЕ
			|	Файлы.Редактирует = &Редактирует";
			
			Если ЗначениеЗаполнено(Параметры.ВладелецФайла) Тогда 
				ТекстЗапроса = ТекстЗапроса + "
					|	И Файлы.ВладелецФайла = &Редактирует";
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ДинамическоеСчитываниеДанных = Ложь;
	СвойстваСписка.ТекстЗапроса                 = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
КонецПроцедуры

#КонецОбласти
