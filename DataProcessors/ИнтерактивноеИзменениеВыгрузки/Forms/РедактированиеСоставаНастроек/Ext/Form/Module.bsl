﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда 
		// Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, Параметры.Объект , , "КомпоновщикОтбораВсехДокументов, ДополнительнаяРегистрация, ДополнительнаяРегистрацияСценарияУзла");
	Для Каждого Строка Из Параметры.Объект.ДополнительнаяРегистрация Цикл
		ЗаполнитьЗначенияСвойств(Объект.ДополнительнаяРегистрация.Добавить(), Строка);
	КонецЦикла;
	Для Каждого Строка Из Параметры.Объект.ДополнительнаяРегистрацияСценарияУзла Цикл
		ЗаполнитьЗначенияСвойств(Объект.ДополнительнаяРегистрацияСценарияУзла.Добавить(), Строка);
	КонецЦикла;
	
	// Компоновщик инициализируем вручную.
	ОбъектОбработка = РеквизитФормыВЗначение("Объект");
	
	Данные = ПолучитьИзВременногоХранилища(Параметры.Объект.АдресКомпоновщикаВсехДокументов);
	ОбъектОбработка.КомпоновщикОтбораВсехДокументов = Новый КомпоновщикНастроекКомпоновкиДанных;
	ОбъектОбработка.КомпоновщикОтбораВсехДокументов.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(Данные.СхемаКомпоновки));
	ОбъектОбработка.КомпоновщикОтбораВсехДокументов.ЗагрузитьНастройки(Данные.Настройки);
	
	ЗначениеВРеквизитФормы(ОбъектОбработка, "Объект");
	
	ПредставлениеТекущейНастройки = Параметры.ПредставлениеТекущейНастройки;
	ПрочитатьСохраненныеНастройки();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВариантыНастроек
//

&НаКлиенте
Процедура ВариантыНастроекВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = ВариантыНастроек.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ТекущиеДанные<>Неопределено Тогда
		ПредставлениеТекущейНастройки = ТекущиеДанные.Представление;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВариантыНастроекПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВариантыНастроекПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	
	ПредставлениеНастройки = Элемент.ТекущиеДанные.Представление;
	
	ТекстЗаголовка = НСтр("ru='Подтверждение'");
	ТекстВопроса   = НСтр("ru='Удалить настройку ""%1""?'");
	
	ТекстВопроса = СтрЗаменить(ТекстВопроса, "%1", ПредставлениеНастройки);
	
	ДополнительныеПараметры = Новый Структура("ПредставлениеНастройки", ПредставлениеНастройки);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеВопросУдаленияВариантаНастроек", ЭтотОбъект, 
		ДополнительныеПараметры);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,ТекстЗаголовка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
//

&НаКлиенте
Процедура СохранитьНастройку(Команда)
	
	Если ПустаяСтрока(ПредставлениеТекущейНастройки) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Не заполнено имя для текущей настройки.'"), , "ПредставлениеТекущейНастройки");
		Возврат;
	КонецЕсли;
		
	Если ВариантыНастроек.НайтиПоЗначению(ПредставлениеТекущейНастройки)<>Неопределено Тогда
		ТекстЗаголовка = НСтр("ru='Подтверждение'");
		ТекстВопроса   = НСтр("ru='Перезаписать существующую настройку ""%1""?'");
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%1", ПредставлениеТекущейНастройки);
		
		ДополнительныеПараметры = Новый Структура("ПредставлениеНастройки", ПредставлениеТекущейНастройки);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеВопросСохраненияВариантаНастроек", ЭтотОбъект, 
			ДополнительныеПараметры);
			
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,ТекстЗаголовка);
		Возврат;
	КонецЕсли;
	
	// Сохраняем без вопросов
	СохранитьИВыполнитьВыборТекущейНастройки();
КонецПроцедуры
	
&НаКлиенте
Процедура ПроизвестиВыбор(Команда)
	ВыполнитьВыбор(ПредставлениеТекущейНастройки);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//

&НаСервере
Функция ЭтотОбъект(НовыйОбъект=Неопределено)
	Если НовыйОбъект=Неопределено Тогда
		Возврат РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	ЗначениеВРеквизитФормы(НовыйОбъект, "Объект");
	Возврат Неопределено;
КонецФункции

&НаСервере
Процедура УдалитьНастройкуСервер(ПредставлениеНастройки)
	ЭтотОбъект().УдалитьВариантНастроек(ПредставлениеНастройки);
КонецПроцедуры

&НаСервере
Процедура ПрочитатьСохраненныеНастройки()
	ЭтаОбработка = ЭтотОбъект();
	
	ФильтрВариантов = ОбменДаннымиСервер.ИнтерактивноеИзменениеВыгрузкиФильтрВарианта(Объект);
	ВариантыНастроек = ЭтаОбработка.ПрочитатьПредставленияСпискаНастроек(Объект.УзелИнформационнойБазы, ФильтрВариантов);
	
	ЭлементСписка = ВариантыНастроек.НайтиПоЗначению(ПредставлениеТекущейНастройки);
	Элементы.ВариантыНастроек.ТекущаяСтрока = ?(ЭлементСписка=Неопределено, Неопределено, ЭлементСписка.ПолучитьИдентификатор())
КонецПроцедуры

&НаСервере
Процедура СохранитьТекущиеНастройки()
	ЭтотОбъект().СохранитьТекущееВНастройки(ПредставлениеТекущейНастройки);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыбор(Представление)
	Если ВариантыНастроек.НайтиПоЗначению(Представление)<>Неопределено И ЗакрыватьПриВыборе Тогда 
		ОповеститьОВыборе( Новый Структура("ДействиеВыбора, ПредставлениеНастройки", 3, Представление) );
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеВопросУдаленияВариантаНастроек(Результат, ДополнительныеПараметры) Экспорт
	Если Результат<>КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьНастройкуСервер(ДополнительныеПараметры.ПредставлениеНастройки);
	ПрочитатьСохраненныеНастройки();
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеВопросСохраненияВариантаНастроек(Результат, ДополнительныеПараметры) Экспорт
	Если Результат<>КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеТекущейНастройки = ДополнительныеПараметры.ПредставлениеНастройки;
	СохранитьИВыполнитьВыборТекущейНастройки();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИВыполнитьВыборТекущейНастройки()
	
	СохранитьТекущиеНастройки();
	ПрочитатьСохраненныеНастройки();
	
	ЗакрыватьПриВыборе = Истина;
	ВыполнитьВыбор(ПредставлениеТекущейНастройки);
КонецПроцедуры;

#КонецОбласти
