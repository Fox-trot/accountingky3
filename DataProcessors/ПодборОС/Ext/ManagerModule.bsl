﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает структуру с параметрами обработки подбора
//
// Используется для кеширования
//
Процедура СтруктураСведенийОДокументе(СтруктураПараметров) Экспорт
	
	СтруктураПараметров = Новый Структура;
	
	Для каждого РеквизитОбработки Из Метаданные.Обработки.ПодборОС.Реквизиты Цикл
		
		СтруктураПараметров.Вставить(РеквизитОбработки.Имя);
		
	КонецЦикла;
	
КонецПроцедуры // СтруктураПараметровПодбора()

// Проверяем минимальный уровень заполнение параметров
//
Процедура ПроверитьЗаполнениеПараметров(ПараметрыПодбора, Отказ) Экспорт
	Перем Ошибки;
	
	СтруктураОбязательныхПараметров = СтруктураОбязательныхПараметров();
	
	Для каждого ЭлементСтруктуры Из СтруктураОбязательныхПараметров Цикл
		
		// Контроль местонахождения- Подразделение.
		Если ЭлементСтруктуры.Ключ = "Подразделение" Тогда 
			Если ПараметрыПодбора.Свойство("КонтролироватьМестонахождение")
				И НЕ ПараметрыПодбора.КонтролироватьМестонахождение Тогда				
				Продолжить;
			КонецЕсли;
			
			Если НЕ ПолучитьФункциональнуюОпцию("УчетДвиженияОСПоПодразделениям") Тогда 
				Продолжить;
			КонецЕсли;			
		КонецЕсли;
		
		// Контроль местонахождения- МОЛ.
		Если ЭлементСтруктуры.Ключ = "МОЛ" Тогда 
			Если ПараметрыПодбора.Свойство("КонтролироватьМестонахождение")
				И НЕ ПараметрыПодбора.КонтролироватьМестонахождение Тогда				
				Продолжить;
			КонецЕсли;
			
			Если НЕ ПолучитьФункциональнуюОпцию("УчетДвиженияОСПоМОЛ") Тогда 
				Продолжить;
			КонецЕсли;
			
			// Исключение- инвентаризаци- МОЛ может быть заполнен в табличной части.
			// В этом случае отбор не устанавливается.
			Если ТипЗнч(ПараметрыПодбора.ДокументСсылка) = Тип("ДокументСсылка.ИнвентаризацияОС") Тогда 
				Продолжить;
			КонецЕсли;	
		КонецЕсли;
		
		ЗначениеПараметров = Неопределено;
		Если НЕ ПараметрыПодбора.Свойство(ЭлементСтруктуры.Ключ, ЗначениеПараметров) Тогда
			
			ТекстОшибки = НСтр("ru = 'Отсутствует обязательный параметр (%1), необходимый для открытия формы подбора ОС.'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ЭлементСтруктуры.Значение);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "", ТекстОшибки, Неопределено);
			
		ИначеЕсли НЕ ЗначениеЗаполнено(ЗначениеПараметров) 
			И НЕ ЭлементСтруктуры.Ключ = "ДокументСсылка" Тогда
			
			ТекстОшибки = НСтр("ru = 'Неверно заполнен обязательный параметр (%1), необходимый для открытия формы подбора ОС.'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ЭлементСтруктуры.Значение);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "", ТекстОшибки, Неопределено);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры // ПроверитьЗаполнениеПараметров()

// Функция возвращает полное имя формы подбора 
//
Функция ПолноеИмяФормыПодбора() Экспорт
	
	Возврат "Обработка.ПодборОС.Форма.Корзина";
	
КонецФункции // ПолноеИмяФормыПодбора()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру обязательных параметров
//
Функция СтруктураОбязательныхПараметров()
	
	Возврат Новый Структура("ДокументСсылка, Дата, Организация, ЭтоДокументПоступления, КонтролироватьМестонахождение, УникальныйИдентификаторФормыВладельца, Подразделение, МОЛ", 
		НСтр("ru = 'Ссылка на регистрирующий документ (может быть пустой)'"), 
		НСтр("ru = 'Дата'"), 
		НСтр("ru = 'Организация'"),
		НСтр("ru = 'Признак- документ поступления'"),
		НСтр("ru = 'Признак- контролировать местонахождение'"),
		НСтр("ru = 'Уникальный идентификатор формы владельца'"),
		НСтр("ru = 'Подразделение'"),
		НСтр("ru = 'Материально-ответственное лицо'"));
	
КонецФункции // СтруктураОбязательныхПараметров()

#КонецОбласти

#КонецЕсли