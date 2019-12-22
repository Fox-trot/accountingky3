﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура добавляет запись в регистр по переданным значениям структуры.
Процедура ДобавитьЗапись(СтруктураЗаписи) Экспорт
	
	НачатьТранзакцию();
	Попытка
		НаборЗаписей = СоздатьНаборЗаписей();
		Если СтруктураЗаписи.Свойство("КонечнаяТочка") Тогда
			НаборЗаписей.Отбор.КонечнаяТочка.Установить(СтруктураЗаписи.КонечнаяТочка);
		КонецЕсли;
		
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, СтруктураЗаписи);
		НаборЗаписей.Записать();
		
		ЗаписатьПароль("Пароль", "WSПароль", СтруктураЗаписи);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Процедура обновляет запись в регистре по переданным значениям структуры.
Процедура ОбновитьЗапись(СтруктураЗаписи) Экспорт
	
	НачатьТранзакцию();
	Попытка
		МенеджерЗаписи = СоздатьМенеджерЗаписи();
		Если СтруктураЗаписи.Свойство("КонечнаяТочка") Тогда
			МенеджерЗаписи.КонечнаяТочка = СтруктураЗаписи.КонечнаяТочка;
		КонецЕсли;
		
		МенеджерЗаписи.Прочитать();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтруктураЗаписи);
		МенеджерЗаписи.Записать();
		
		ЗаписатьПароль("Пароль", "WSПароль", СтруктураЗаписи);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Для внутреннего использования.
// 
Функция НастройкиТранспортаWS(КонечнаяТочка, ПараметрыАутентификации = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ВидТранспортаСообщенийОбменаПоУмолчанию", Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	Результат.Вставить("WSURLВебСервиса");
	Результат.Вставить("WSИмяПользователя");
	Результат.Вставить("WSЗапомнитьПароль");
	Результат.Вставить("WSПароль");
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НастройкиТранспорта.АдресВебСервиса КАК WSURLВебСервиса,
	|	НастройкиТранспорта.ИмяПользователя КАК WSИмяПользователя,
	|	НастройкиТранспорта.ЗапомнитьПароль КАК WSЗапомнитьПароль
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбменаСообщениями КАК НастройкиТранспорта
	|ГДЕ
	|	НастройкиТранспорта.КонечнаяТочка = &КонечнаяТочка");
	Запрос.УстановитьПараметр("КонечнаяТочка", КонечнаяТочка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	WSПароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(КонечнаяТочка, "WSПароль", Истина);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ТипЗнч(WSПароль) = Тип("Строка")
		Или WSПароль = Неопределено Тогда
		
		Результат.Вставить("WSПароль", WSПароль);
	Иначе
		ВызватьИсключение НСтр("ru='Ошибка при извлечении пароля из безопасного хранилища.'");
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыАутентификации) = Тип("Структура") Тогда // Инициация обмена пользователем с клиента.
		
		Если ПараметрыАутентификации.ИспользоватьТекущегоПользователя Тогда
			
			Результат.WSИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
			
		КонецЕсли;
		
		Пароль = Неопределено;
		
		Если ПараметрыАутентификации.Свойство("Пароль", Пароль)
			И Пароль <> Неопределено Тогда // Ввели пароль на клиенте
			
			Результат.WSПароль = Пароль;
			
		Иначе // Пароль на клиенте не вводили.
			
			Пароль = ПарольСинхронизацииДанных(КонечнаяТочка);
			Результат.WSПароль = ?(Пароль = Неопределено, "", Пароль);
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПараметрыАутентификации) = Тип("Строка") Тогда
		Результат.WSПароль = ПараметрыАутентификации;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьПароль(ИмяПароляВСтруктуре, ИмяПароляПриЗаписи, СтруктураЗаписи)
	
	Если СтруктураЗаписи.Свойство(ИмяПароляВСтруктуре) Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(СтруктураЗаписи.КонечнаяТочка,
			СтруктураЗаписи[ИмяПароляВСтруктуре], ИмяПароляПриЗаписи);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Функция ПарольСинхронизацииДанных(УзелИнформационнойБазы)
	
	Пароль = Неопределено;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		УстановитьПривилегированныйРежим(Истина);
		Пароль = ПараметрыСеанса.ПаролиСинхронизацииДанных.Получить(УзелИнформационнойБазы);
	КонецЕсли;
	
	Возврат Пароль;
	
КонецФункции

#КонецОбласти

#КонецЕсли