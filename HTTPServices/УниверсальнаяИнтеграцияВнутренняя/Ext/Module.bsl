﻿
#Область ОбработчикиСобытий

// Обработчик метода PUT /hooks/{zone}/{rule_id}/{object_id}
// В теле передаются данные объекта по правилу трансляции.
//
// Параметры URL:
//  zone - номер области данных.
//  rule_id - идентификатор правила трансляции.
//  object_id - ключ объекта.
// 
// Возвращаемые ответы:                     
//  200 - оповещение обработано.
//  500 - внутренние ошибки:
//   - Номер области должен содержать только цифры.
//   - Операция может быть выполнена только в разделенном сеансе.
//   - Операция не может быть выполнена в базе с отключенным разделением сеанса.
//   - Другие внутренние ошибки.
//   
Функция ОповещениеПолучить(Запрос)
    
    Словарь = УниверсальнаяИнтеграцияСловарь;
    ИдентификаторПравила = Запрос.ПараметрыURL.Получить("rule_id");
    КлючОбъекта = Запрос.ПараметрыURL.Получить("object_id");
    НомерОбласти = Запрос.ПараметрыURL.Получить("zone");
    Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(НомерОбласти) Тогда
        ВызватьИсключение Словарь.НомерОбластиДолженСодержатьТолькоЦифры();        
    КонецЕсли;
    
    УстановитьПривилегированныйРежим(Истина);
    Если РаботаВМоделиСервиса.РазделениеВключено() Тогда
        Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
            ВызватьИсключение Словарь.ОперацияНеМожетБытьВыполненаВРазделенномСеансе();    
        Иначе
            РаботаВМоделиСервиса.УстановитьРазделениеСеанса(Истина, Число(НомерОбласти));
        Конецесли;
    Иначе
        ВызватьИсключение Словарь.ОперацияНеМожетБытьВыполненаВБазеСОтключеннымРазделением();
    КонецЕсли;
    
    ПотокДанных = Запрос.ПолучитьТелоКакПоток();
    Данные = РаботаВМоделиСервисаБТС.СтруктураИзПотокаJSON(ПотокДанных);
    УниверсальнаяИнтеграцияПереопределяемый.ОбработатьОповещениеОбИзменении(ИдентификаторПравила, КлючОбъекта, Данные);
    Если Данные <> Неопределено Тогда
        УниверсальнаяИнтеграция.ЗаписатьПолученныеДанныеОбъекта(ИдентификаторПравила, КлючОбъекта, Данные);
    КонецЕсли;
    
    РаботаВМоделиСервиса.УстановитьРазделениеСеанса(Ложь);
    УстановитьПривилегированныйРежим(Ложь);
    
    Ответ = Новый HTTPСервисОтвет(200);
    Возврат Ответ;
    
КонецФункции

#КонецОбласти 
