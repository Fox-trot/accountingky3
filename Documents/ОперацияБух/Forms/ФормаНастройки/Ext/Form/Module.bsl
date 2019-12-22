﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТаблицаЗначенийРегистры = ПолучитьИзВременногоХранилища(Параметры.АдресСпискаРегистров);
	ЗначениеВРеквизитФормы(ТаблицаЗначенийРегистры, "Регистры");
	
	Для Каждого СтрокаРегистра Из Регистры Цикл
		Если СтрокаРегистра.ТипРегистра = "РегистрНакопления" Тогда
			СписокРегистровНакопления.Добавить(
				СтрокаРегистра.Имя, 
				СтрокаРегистра.Синоним, 
				СтрокаРегистра.Отображение);
		ИначеЕсли СтрокаРегистра.ТипРегистра="РегистрСведений" Тогда
			СписокРегистровСведений.Добавить(
				СтрокаРегистра.Имя, 
				СтрокаРегистра.Синоним, 
				СтрокаРегистра.Отображение);
		КонецЕсли;	
	КонецЦикла;
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрименитьНастройку(Команда)
	
	// Получим список изменений
	// и отдельно список представлений регистров, из которых будут удалены движения
	СписокИзменений   = Новый СписокЗначений;
	УдаленныеДвижения = Новый Массив;
	Для Каждого Регистр Из Регистры Цикл
		
		СтрокаПользовательскогоСписка = НайтиВПользовательскомСписке(Регистр.Имя, Регистр.ТипРегистра);
		
		Если СтрокаПользовательскогоСписка = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрокаПользовательскогоСписка.Пометка <> Регистр.Отображение Тогда
			СписокИзменений.Добавить(Регистр.Имя, Регистр.Синоним, СтрокаПользовательскогоСписка.Пометка);
		КонецЕсли;
		
		Если НЕ СтрокаПользовательскогоСписка.Пометка И Регистр.ЕстьДвижения Тогда
			УдаленныеДвижения.Добавить(Регистр.Синоним);
		КонецЕсли;
			
	КонецЦикла;
	
	// Сообщим о возможных последствиях - 
	// "Будут удалены движения из регистров .... Продолжить?"
	Если УдаленныеДвижения.Количество() > 0 Тогда
		
		Если УдаленныеДвижения.Количество() = 1 Тогда
			ТекстВопроса = НСтр("ru = 'Будут удалены движения регистра ""%ИмяРегистра%"". 
			|Продолжить?'");
			ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ИмяРегистра%", УдаленныеДвижения[0]);
		Иначе
			ТекстВопроса = НСтр("ru = 'Будут удалены движения регистров %СписокРегистров%. 
			|Продолжить?'");
			ТекстСписокРегистров = "";
			Для Каждого ПредставлениеРегистра Из УдаленныеДвижения Цикл
				ТекстСписокРегистров = ТекстСписокРегистров + Символы.ПС + " - " + ПредставлениеРегистра;
			КонецЦикла;
			ТекстВопроса = СтрЗаменить(ТекстВопроса, "%СписокРегистров%", ТекстСписокРегистров);
		КонецЕсли;
		
		Оповещение = Новый ОписаниеОповещения("ВопросПрименитьНастройкуЗавершение", ЭтотОбъект, СписокИзменений);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		// Вернем список изменений
		Закрыть(СписокИзменений);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартнуюНастройку(Команда)
	
	// Стандартная настройка - "включены" только те регистры, по которым есть движения
	
	ИзменитьФлажки(Ложь); // Снять
	
	Для Каждого Регистр Из Регистры Цикл
		
		Если НЕ Регистр.ЕстьДвижения Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПользовательскогоСписка = НайтиВПользовательскомСписке(Регистр.Имя, Регистр.ТипРегистра);
		
		Если СтрокаПользовательскогоСписка <> Неопределено Тогда
			СтрокаПользовательскогоСписка.Пометка = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВсеФлажки(Команда)
	
	ИзменитьФлажки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеФлажки(Команда)
	
	ИзменитьФлажки(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьФлажки(Пометка)
	
	Для Каждого СтрокаРегистра Из СписокРегистровНакопления Цикл
		СтрокаРегистра.Пометка = Пометка;
	КонецЦикла;
	
	Для Каждого СтрокаРегистра Из СписокРегистровСведений Цикл
		СтрокаРегистра.Пометка = Пометка;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция НайтиВПользовательскомСписке(Имя, ТипРегистра)
	
	Если ТипРегистра = "РегистрНакопления" Тогда
		ПользовательскийСписок = СписокРегистровНакопления;
	ИначеЕсли ТипРегистра = "РегистрСведений" Тогда
		ПользовательскийСписок = СписокРегистровСведений;
	Иначе
		ПользовательскийСписок = Новый СписокЗначений;
	КонецЕсли;
	
	Возврат ПользовательскийСписок.НайтиПоЗначению(Имя);
	
КонецФункции

&НаКлиенте
Процедура ВопросПрименитьНастройкуЗавершение(Результат, СписокИзменений) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		// Вернем список изменений
		Закрыть(СписокИзменений);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти