﻿
#Область ОписаниеПеременных

// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	МестоЗапуска = Параметры.МестоЗапуска;
	
	Элементы.НадписьСообщенияВТехПоддержку.Заголовок =
		ИнтернетПоддержкаПользователейКлиентСервер.ФорматированныйЗаголовок(
			ИнтернетПоддержкаПользователейКлиентСервер.ПодставитьДомен(
				НСтр("ru = '<body>При возникновении проблем отправьте письмо по адресу <a href=""SendMail"">webits-info@1c.ru</a></body>'")));
	
	ОписаниеОшибки = Параметры.ОписаниеОшибки;
	ОписаниеОшибкиЗаполнено = НЕ ПустаяСтрока(ОписаниеОшибки);
	КлючСохраненияПоложенияОкна = МестоЗапуска + Строка(ОписаниеОшибкиЗаполнено);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "ПодробноеОписаниеОшибки, ПриНачалеРаботыСистемы, Логин");
	
	Если ТипЗнч(Параметры.СтартовыеПараметры) = Тип("Структура") Тогда
		СтартовыеПараметры = Параметры.СтартовыеПараметры;
	Иначе
		СтартовыеПараметры = Новый Структура;
	КонецЕсли;
	
	Элементы.ОписаниеОшибки.Видимость = ОписаниеОшибкиЗаполнено;
	
	Если Параметры.ПриНачалеРаботыСистемы Тогда
		ЗапускатьПриСтарте = Истина;
	Иначе
		Элементы.ЗапускатьПриСтарте.Видимость = Ложь;
	КонецЕсли;
	
	// Настройка внешнего вида формы
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ГруппаЗаголовка.Отображение           = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Элементы.ГруппаИнформационнойЧасти.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьСообщенияВТехПоддержкуОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "SendMail" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если МестоЗапуска = "handStartNew"
			Или МестоЗапуска = "systemStartNew" Тогда
			
			Тема = НСтр("ru = 'Интернет-поддержка. Обращение к монитору Интернет-поддержки.'");
			Тело = НСтр("ru = 'Возникает ошибка обращения к монитору Интернет-поддержки.'");
			
		ИначеЕсли МестоЗапуска = "taxcomGetID" Тогда
			
			Тема = НСтр("ru = 'Интернет-поддержка. Обращение к 1С-Такском'");
			Тело = НСтр("ru = 'Возникает ошибка при обращении к сервису получения идентификатора 1С-Такском.'");
			
		ИначеЕсли МестоЗапуска = "taxcomPrivat" Тогда
			
			Тема = НСтр("ru = 'Интернет-поддержка. Обращение к 1С-Такском'");
			Тело = НСтр("ru = 'Возникает ошибка при обращении к сервису получения идентификатора 1С-Такском.'");
			
		Иначе
			
			// В случае, если имя бизнес-процесса не было передано до возникновения ошибки
			Тема = НСтр("ru = 'Интернет-поддержка. Ошибка обращения к сервису'");
			Тело = НСтр("ru = 'Возникает ошибка при обращении к сервису Интернет-поддержки.'");
			
		КонецЕсли;
		
		
		Если Не ПустаяСтрока(ПодробноеОписаниеОшибки) Тогда
			Тело = Тело + Символы.ПС + НСтр("ru = 'Описание ошибки:'")
				+ Символы.ПС + ПодробноеОписаниеОшибки;
		ИначеЕсли Не ПустаяСтрока(ОписаниеОшибки) Тогда
			Тело = Тело + Символы.ПС + НСтр("ru = 'Описание ошибки:'")
				+ Символы.ПС + ОписаниеОшибки;
		КонецЕсли;
		
		ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
			Тема,
			Тело,
			,
			,
			Новый Структура("Логин, Пароль",
				?(КонтекстВзаимодействия = Неопределено,
					"",
					ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(КонтекстВзаимодействия.КСКонтекст, "login")),
				?(КонтекстВзаимодействия = Неопределено,
					"",
					ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(КонтекстВзаимодействия.КСКонтекст, "password"))));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапускатьПриСтартеПриИзменении(Элемент)
	
	УстановитьНастройкуЗапускатьПриСтарте(ЗапускатьПриСтарте);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияИнформационнойЧастиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "open:log" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Новый Структура("Пользователь", ИмяПользователя()));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПовторитьПопыткуПодключения(Команда)
	
	Закрыть();
	ИнтернетПоддержкаПользователейКлиент.СтартоватьМеханизм(МестоЗапуска, СтартовыеПараметры, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура УстановитьНастройкуЗапускатьПриСтарте(ЗначениеНастройки)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ИнтернетПоддержкаПользователей",
		"ВсегдаПоказыватьПриСтартеПрограммы",
		ЗначениеНастройки);
	
КонецПроцедуры

#КонецОбласти
